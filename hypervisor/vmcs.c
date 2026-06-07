// SPDX-License-Identifier: GPL-2.0
/*
 * vmcs.c — VMCS initialization: guest state, host state, controls
 *
 * Core protection: CR4_GUEST_HOST_MASK = X86_CR4_SMEP
 * Any guest attempt to clear CR4.SMEP triggers a VM-exit.
 */

#include <linux/kernel.h>
#include <linux/slab.h>
#include <asm/msr.h>
#include <asm/processor.h>
#include <asm/desc.h>
#include <asm/segment.h>

#include "vmx.h"

extern u32 vmx_adjust_ctrl(u32, u32);

/* Check IA32_VMX_BASIC bit 55: use TRUE control MSRs if set */
static bool use_true_ctls(void)
{
	u64 basic;
	rdmsrl(MSR_VMX_BASIC, basic);
	return !!(basic & BIT_ULL(55));
}

static u32 pin_ctrl(u32 desired)
{
	return vmx_adjust_ctrl(desired,
		use_true_ctls() ? MSR_VMX_TRUE_PINBASED : MSR_VMX_PINBASED);
}

static u32 pri_ctrl(u32 desired)
{
	return vmx_adjust_ctrl(desired,
		use_true_ctls() ? MSR_VMX_TRUE_PROCBASED : MSR_VMX_PROCBASED);
}

static u32 sec_ctrl(u32 desired)
{
	/* Secondary controls always use MSR_VMX_PROCBASED2 */
	return vmx_adjust_ctrl(desired, MSR_VMX_PROCBASED2);
}

static u32 exit_ctrl(u32 desired)
{
	return vmx_adjust_ctrl(desired,
		use_true_ctls() ? MSR_VMX_TRUE_EXIT : MSR_VMX_EXIT);
}

static u32 entry_ctrl(u32 desired)
{
	return vmx_adjust_ctrl(desired,
		use_true_ctls() ? MSR_VMX_TRUE_ENTRY : MSR_VMX_ENTRY);
}

/* Get segment access rights via LAR instruction */
static u32 get_ar(u16 sel)
{
	u32 ar;

	if (sel == 0)
		return 0x10000; /* unusable */

	asm volatile("lar %1, %0\n\t"
		     : "=r"(ar) : "r"((u32)sel));

	return (ar >> 8) & 0xf0ff; /* strip limit bits 11:8 from LAR result */
}

/* Read TSS base from GDT (64-bit TSS descriptor is 16 bytes) */
static u64 get_tr_base(u16 tr_sel)
{
	struct desc_ptr gdtr;
	struct ldttss_desc *tss_desc;
	u64 base;

	native_store_gdt(&gdtr);
	tss_desc = (struct ldttss_desc *)(gdtr.address + (tr_sel & ~0x7));

	base = (u64)tss_desc->base0
	     | ((u64)tss_desc->base1 << 16)
	     | ((u64)tss_desc->base2 << 24)
	     | ((u64)tss_desc->base3 << 32);

	return base;
}

/* Read fs_base / gs_base from MSRs */
static u64 read_fs_base(void)  { u64 v; rdmsrl(MSR_FS_BASE,  v); return v; }
static u64 read_gs_base(void)  { u64 v; rdmsrl(MSR_GS_BASE,  v); return v; }

/* Setup VMCS for current CPU. Called after VMXON + VMPTRLD. */
int vmcs_setup(struct vcpu *vcpu)
{
	struct desc_ptr gdtr, idtr;
	u16 cs, ss, ds, es, fs, gs, tr, ldtr_sel;
	u64 cr0, cr3, cr4;
	u64 efer, sysenter_cs, sysenter_esp, sysenter_eip;
	u64 dr7;
	u32 sec_desired;
	u64 sec_msr;
	u8 err;

	/* VMCLEAR: reset VMCS state */
	asm volatile("vmclear %1\n\t"
		     "setna %0\n\t"
		     : "=qm"(err) : "m"(vcpu->vmcs_pa)
		     : "cc", "memory");
	if (err) {
		pr_err("[hv] VMCLEAR failed\n");
		return -EIO;
	}

	/* VMPTRLD: make this VMCS current */
	asm volatile("vmptrld %1\n\t"
		     "setna %0\n\t"
		     : "=qm"(err) : "m"(vcpu->vmcs_pa)
		     : "cc", "memory");
	if (err) {
		pr_err("[hv] VMPTRLD failed\n");
		return -EIO;
	}

	/* Capture current CPU state */
	asm volatile("mov %%cs, %0" : "=r"(cs));
	asm volatile("mov %%ss, %0" : "=r"(ss));
	asm volatile("mov %%ds, %0" : "=r"(ds));
	asm volatile("mov %%es, %0" : "=r"(es));
	asm volatile("mov %%fs, %0" : "=r"(fs));
	asm volatile("mov %%gs, %0" : "=r"(gs));
	asm volatile("str %0"       : "=r"(tr));
	asm volatile("sldt %0"      : "=r"(ldtr_sel));
	asm volatile("mov %%dr7, %0": "=r"(dr7));

	native_store_gdt(&gdtr);
	store_idt(&idtr);

	cr0 = hv_read_cr0();
	cr3 = hv_read_cr3();
	cr4 = hv_read_cr4();

	rdmsrl(MSR_EFER,                  efer);
	rdmsrl(MSR_IA32_SYSENTER_CS,      sysenter_cs);
	rdmsrl(MSR_IA32_SYSENTER_ESP,     sysenter_esp);
	rdmsrl(MSR_IA32_SYSENTER_EIP,     sysenter_eip);

	/* ---- VMCS control fields ---- */

	vmcs_write32(VMCS_PIN_EXEC_CTRL,  pin_ctrl(0));
	vmcs_write32(VMCS_PRI_EXEC_CTRL,  pri_ctrl(PRI_USE_MSR_BITMAPS | PRI_ACTIVATE_SEC));

	/* Enable secondary controls that avoid spurious VM-exits */
	sec_desired = 0;
	rdmsrl(MSR_VMX_PROCBASED2, sec_msr);
	if ((sec_msr >> 32) & SEC_RDTSCP)   sec_desired |= SEC_RDTSCP;
	if ((sec_msr >> 32) & SEC_INVPCID)  sec_desired |= SEC_INVPCID;
	if ((sec_msr >> 32) & SEC_XSAVES)   sec_desired |= SEC_XSAVES;
	vmcs_write32(VMCS_SEC_EXEC_CTRL, sec_ctrl(sec_desired));

	vmcs_write32(VMCS_EXIT_CTRL,
		exit_ctrl(VMEXIT_HOST_64BIT | VMEXIT_LOAD_EFER | VMEXIT_SAVE_EFER));
	vmcs_write32(VMCS_ENTRY_CTRL,
		entry_ctrl(VMENTRY_IA32E_GUEST | VMENTRY_LOAD_EFER));

	vmcs_write32(VMCS_EXCEPTION_BITMAP, 0); /* no exception exits */
	vmcs_write32(VMCS_ENTRY_INTR_INFO,  0);

	/* VMCS link pointer = 0xffffffffffffffff (no shadow VMCS) */
	vmcs_write64(VMCS_LINK_POINTER, ~0ULL);

	/* MSR bitmap: zeroed page = no MSR exits */
	vmcs_write64(VMCS_MSR_BITMAP, vcpu->msr_bitmap_pa);

	/* ---- CR4 protection: own the SMEP bit ---- */
	vmcs_writel(VMCS_CR4_GUEST_MASK, X86_CR4_SMEP);
	/* READ_SHADOW must have SMEP=1 so any write with SMEP=0 triggers VM-exit.
	 * If shadow had SMEP=0, a guest write of SMEP=0 would be a no-op (no change
	 * detected) and the hardware would silently allow it. */
	vmcs_writel(VMCS_CR4_READ_SHADOW, cr4 | X86_CR4_SMEP);
	vmcs_writel(VMCS_CR0_GUEST_MASK, 0);
	vmcs_writel(VMCS_CR0_READ_SHADOW, cr0);

	/* ---- Guest state ---- */

	vmcs_write16(VMCS_GUEST_CS_SEL,   cs);
	vmcs_write16(VMCS_GUEST_SS_SEL,   ss);
	vmcs_write16(VMCS_GUEST_DS_SEL,   ds);
	vmcs_write16(VMCS_GUEST_ES_SEL,   es);
	vmcs_write16(VMCS_GUEST_FS_SEL,   fs);
	vmcs_write16(VMCS_GUEST_GS_SEL,   gs);
	vmcs_write16(VMCS_GUEST_TR_SEL,   tr);
	vmcs_write16(VMCS_GUEST_LDTR_SEL, ldtr_sel);

	vmcs_write32(VMCS_GUEST_CS_LIMIT,   0xffffffff);
	vmcs_write32(VMCS_GUEST_SS_LIMIT,   0xffffffff);
	vmcs_write32(VMCS_GUEST_DS_LIMIT,   0xffffffff);
	vmcs_write32(VMCS_GUEST_ES_LIMIT,   0xffffffff);
	vmcs_write32(VMCS_GUEST_FS_LIMIT,   0xffffffff);
	vmcs_write32(VMCS_GUEST_GS_LIMIT,   0xffffffff);
	vmcs_write32(VMCS_GUEST_TR_LIMIT,   0xffff);
	vmcs_write32(VMCS_GUEST_LDTR_LIMIT, 0xffff);
	vmcs_write32(VMCS_GUEST_GDTR_LIMIT, gdtr.size);
	vmcs_write32(VMCS_GUEST_IDTR_LIMIT, idtr.size);

	vmcs_write32(VMCS_GUEST_CS_AR,   get_ar(cs));
	vmcs_write32(VMCS_GUEST_SS_AR,   get_ar(ss));
	vmcs_write32(VMCS_GUEST_DS_AR,   get_ar(ds));
	vmcs_write32(VMCS_GUEST_ES_AR,   get_ar(es));
	vmcs_write32(VMCS_GUEST_FS_AR,   get_ar(fs));
	vmcs_write32(VMCS_GUEST_GS_AR,   get_ar(gs));
	vmcs_write32(VMCS_GUEST_TR_AR,   get_ar(tr));
	vmcs_write32(VMCS_GUEST_LDTR_AR, 0x10000);  /* unusable */

	vmcs_writel(VMCS_GUEST_CS_BASE,   0);
	vmcs_writel(VMCS_GUEST_SS_BASE,   0);
	vmcs_writel(VMCS_GUEST_DS_BASE,   0);
	vmcs_writel(VMCS_GUEST_ES_BASE,   0);
	vmcs_writel(VMCS_GUEST_FS_BASE,   read_fs_base());
	vmcs_writel(VMCS_GUEST_GS_BASE,   read_gs_base());
	vmcs_writel(VMCS_GUEST_TR_BASE,   get_tr_base(tr));
	vmcs_writel(VMCS_GUEST_LDTR_BASE, 0);
	vmcs_writel(VMCS_GUEST_GDTR_BASE, gdtr.address);
	vmcs_writel(VMCS_GUEST_IDTR_BASE, idtr.address);

	vmcs_writel(VMCS_GUEST_CR0, cr0);
	vmcs_writel(VMCS_GUEST_CR3, cr3);
	vmcs_writel(VMCS_GUEST_CR4, cr4 | X86_CR4_SMEP); /* enforce SMEP on entry */
	vmcs_writel(VMCS_GUEST_DR7, dr7);

	vmcs_write32(VMCS_GUEST_SYSENTER_CS,  (u32)sysenter_cs);
	vmcs_writel(VMCS_GUEST_SYSENTER_ESP,   sysenter_esp);
	vmcs_writel(VMCS_GUEST_SYSENTER_EIP,   sysenter_eip);

	vmcs_write64(VMCS_GUEST_EFER,     efer);
	vmcs_write64(VMCS_GUEST_DEBUGCTL, 0);

	vmcs_write32(VMCS_GUEST_INTR_STATE, 0);
	vmcs_write32(VMCS_GUEST_ACTIVITY,   0);  /* active */
	vmcs_writel(VMCS_GUEST_PENDING_DBG, 0);

	/* GUEST_RIP and GUEST_RSP are set in entry.S vmx_launch() */

	/* ---- Host state ---- */

	vmcs_write16(VMCS_HOST_CS_SEL, __KERNEL_CS);
	vmcs_write16(VMCS_HOST_SS_SEL, __KERNEL_DS);
	vmcs_write16(VMCS_HOST_DS_SEL, __KERNEL_DS);
	vmcs_write16(VMCS_HOST_ES_SEL, __KERNEL_DS);
	vmcs_write16(VMCS_HOST_FS_SEL, 0);
	vmcs_write16(VMCS_HOST_GS_SEL, 0);
	vmcs_write16(VMCS_HOST_TR_SEL, tr);

	vmcs_writel(VMCS_HOST_CR0, cr0);
	vmcs_writel(VMCS_HOST_CR3, cr3);
	vmcs_writel(VMCS_HOST_CR4, cr4);

	vmcs_writel(VMCS_HOST_FS_BASE,    read_fs_base());
	vmcs_writel(VMCS_HOST_GS_BASE,    read_gs_base());
	vmcs_writel(VMCS_HOST_TR_BASE,    get_tr_base(tr));
	vmcs_writel(VMCS_HOST_GDTR_BASE,  gdtr.address);
	vmcs_writel(VMCS_HOST_IDTR_BASE,  idtr.address);

	vmcs_write32(VMCS_HOST_SYSENTER_CS,   (u32)sysenter_cs);
	vmcs_writel(VMCS_HOST_SYSENTER_ESP,   sysenter_esp);
	vmcs_writel(VMCS_HOST_SYSENTER_EIP,   sysenter_eip);

	vmcs_write64(VMCS_HOST_EFER, efer);

	vmcs_writel(VMCS_HOST_RSP, vcpu->host_rsp);
	vmcs_writel(VMCS_HOST_RIP, (unsigned long)vmexit_entry);

	pr_info("[hv] VMCS configured on CPU %d (SMEP protection active)\n",
		smp_processor_id());
	return 0;
}

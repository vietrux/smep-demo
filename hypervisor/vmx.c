// SPDX-License-Identifier: GPL-2.0
/*
 * vmx.c — VMX operation: enable/disable per CPU, VMXON/VMXOFF
 */

#include <linux/kernel.h>
#include <linux/slab.h>
#include <linux/mm.h>
#include <linux/io.h>
#include <asm/msr.h>
#include <asm/processor.h>
#include <asm/desc.h>

#include "vmx.h"

struct vcpu __percpu *g_vcpu;
atomic64_t            g_smep_blocks = ATOMIC64_INIT(0);

/* Adjust a VMCS control value against the MSR-specified allowed bits.
 * allowed0 (low 32): bits that MUST be 1.
 * allowed1 (high 32): bits that MAY be 1.
 */
static u32 adjust_ctrl(u32 desired, u32 msr_idx)
{
	u64 msr;
	rdmsrl(msr_idx, msr);
	desired |= (u32)(msr & 0xffffffff);       /* OR with must-be-1 bits */
	desired &= (u32)((msr >> 32) & 0xffffffff); /* AND with may-be-1 bits */
	return desired;
}

/* Check and unlock VMX in IA32_FEATURE_CONTROL if needed */
static int vmx_check_feature_control(void)
{
	u64 fc;

	rdmsrl(MSR_FEATURE_CONTROL, fc);

	if (fc & FEATURE_CTRL_LOCKED) {
		if (!(fc & FEATURE_CTRL_VMXON_OUTSIDE_SMX)) {
			pr_err("[hv] IA32_FEATURE_CONTROL locked, VMXON disabled\n");
			return -EPERM;
		}
		return 0;
	}

	fc |= FEATURE_CTRL_VMXON_OUTSIDE_SMX | FEATURE_CTRL_LOCKED;
	wrmsrl(MSR_FEATURE_CONTROL, fc);
	return 0;
}

/* Enable VMX on current CPU (must be called on each CPU individually) */
int vmx_cpu_enable(void)
{
	struct vcpu *vcpu = this_cpu_ptr(g_vcpu);
	u64 vmx_basic;
	u32 revision;
	unsigned long cr0, cr4;
	int ret;
	u8 err;

	/* Verify CPU supports VMX */
	if (!(boot_cpu_data.x86_capability[CPUID_1_ECX] & BIT(5))) {
		pr_err("[hv] CPU does not support VMX\n");
		return -ENODEV;
	}

	ret = vmx_check_feature_control();
	if (ret)
		return ret;

	/* Set CR4.VMXE */
	cr4 = hv_read_cr4();
	hv_write_cr4(cr4 | X86_CR4_VMXE);

	/* Fix CR0 per VMX requirements (FIXED0=must-be-1, FIXED1=may-be-1) */
	{
		u64 fixed0, fixed1;
		rdmsrl(MSR_VMX_CR0_FIXED0, fixed0);
		rdmsrl(MSR_VMX_CR0_FIXED1, fixed1);
		cr0 = (hv_read_cr0() | (unsigned long)fixed0) & (unsigned long)fixed1;
		hv_write_cr0(cr0);
	}

	/* Get VMX revision ID from IA32_VMX_BASIC */
	rdmsrl(MSR_VMX_BASIC, vmx_basic);
	revision = (u32)(vmx_basic & 0x7fffffff);

	/* Allocate and initialize VMXON region */
	vcpu->vmxon = (struct vmxon_region *)get_zeroed_page(GFP_KERNEL);
	if (!vcpu->vmxon) {
		pr_err("[hv] failed to allocate VMXON region\n");
		return -ENOMEM;
	}
	vcpu->vmxon->revision_id = revision;
	vcpu->vmxon_pa = virt_to_phys(vcpu->vmxon);

	/* Allocate VMCS region */
	vcpu->vmcs = (struct vmcs_region *)get_zeroed_page(GFP_KERNEL);
	if (!vcpu->vmcs) {
		free_page((unsigned long)vcpu->vmxon);
		pr_err("[hv] failed to allocate VMCS region\n");
		return -ENOMEM;
	}
	vcpu->vmcs->revision_id = revision;
	vcpu->vmcs_pa = virt_to_phys(vcpu->vmcs);

	/* Allocate MSR bitmap (zeroed = no MSR exits) */
	vcpu->msr_bitmap = (void *)get_zeroed_page(GFP_KERNEL);
	if (!vcpu->msr_bitmap) {
		free_page((unsigned long)vcpu->vmcs);
		free_page((unsigned long)vcpu->vmxon);
		pr_err("[hv] failed to allocate MSR bitmap\n");
		return -ENOMEM;
	}
	vcpu->msr_bitmap_pa = virt_to_phys(vcpu->msr_bitmap);

	/* Allocate host stack */
	vcpu->host_stack = (void *)__get_free_pages(GFP_KERNEL, 2); /* 4 pages */
	if (!vcpu->host_stack) {
		free_page((unsigned long)vcpu->msr_bitmap);
		free_page((unsigned long)vcpu->vmcs);
		free_page((unsigned long)vcpu->vmxon);
		pr_err("[hv] failed to allocate host stack\n");
		return -ENOMEM;
	}
	/* HOST_RSP - 8 so that after 15 pushes in vmexit_entry, RSP is 16-byte aligned */
	vcpu->host_rsp = (u64)vcpu->host_stack + (4 * PAGE_SIZE) - 8;

	/* VMXON */
	asm volatile("vmxon %1\n\t"
		     "setna %0\n\t"
		     : "=qm"(err)
		     : "m"(vcpu->vmxon_pa)
		     : "cc", "memory");
	if (err) {
		pr_err("[hv] VMXON failed on CPU %d\n", smp_processor_id());
		free_pages((unsigned long)vcpu->host_stack, 2);
		free_page((unsigned long)vcpu->vmcs);
		free_page((unsigned long)vcpu->vmxon);
		hv_write_cr4(hv_read_cr4() & ~X86_CR4_VMXE);
		return -EIO;
	}

	pr_info("[hv] VMXON success on CPU %d\n", smp_processor_id());
	return 0;
}

/* Disable VMX on current CPU */
void vmx_cpu_disable(void)
{
	struct vcpu *vcpu = this_cpu_ptr(g_vcpu);

	asm volatile("vmclear %0\n\t" : : "m"(vcpu->vmcs_pa) : "cc", "memory");
	asm volatile("vmxoff\n\t" : : : "cc");
	hv_write_cr4(hv_read_cr4() & ~X86_CR4_VMXE);

	if (vcpu->host_stack)
		free_pages((unsigned long)vcpu->host_stack, 2);
	if (vcpu->msr_bitmap)
		free_page((unsigned long)vcpu->msr_bitmap);
	if (vcpu->vmcs)
		free_page((unsigned long)vcpu->vmcs);
	if (vcpu->vmxon)
		free_page((unsigned long)vcpu->vmxon);

	vcpu->vmxon = NULL;
	vcpu->vmcs  = NULL;
	vcpu->host_stack = NULL;

	pr_info("[hv] VMXOFF on CPU %d\n", smp_processor_id());
}

/* Called by vmcs.c — exposed here to avoid circular deps */
u32 vmx_adjust_ctrl(u32 desired, u32 msr)
{
	return adjust_ctrl(desired, msr);
}

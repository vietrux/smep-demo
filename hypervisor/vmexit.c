// SPDX-License-Identifier: GPL-2.0
/*
 * vmexit.c — VM-exit dispatch handler
 *
 * Handles:
 *   CPUID       — passthrough (execute on host, return results to guest)
 *   CR_ACCESS   — intercept CR4.SMEP clear attempts, force SMEP back on
 *   INVD        — replace with WBINVD (safe)
 *   XSETBV      — passthrough
 *   others      — advance RIP and resume (best-effort for demo)
 */

#include <linux/kernel.h>
#include <linux/atomic.h>
#include <linux/smp.h>
#include <asm/processor.h>
#include <asm/cpufeatures.h>

#include "vmx.h"

static void advance_rip(void)
{
	unsigned long rip  = vmcs_readl(VMCS_GUEST_RIP);
	unsigned long len  = vmcs_read32(VMCS_EXIT_INSN_LEN);
	vmcs_writel(VMCS_GUEST_RIP, rip + len);
}

/*
 * Map VMX exit-qualification register index (0=RAX..15=R15) to the
 * corresponding field in struct guest_regs.
 * struct layout: r15 at index 0, r14 at 1, ..., rax at index 14.
 */
static u64 reg_value(struct guest_regs *regs, int idx)
{
	u64 *r = (u64 *)regs;
	static const int map[16] = {
		14, /* RAX → struct index 14 */
		13, /* RCX → struct index 13 */
		12, /* RDX → struct index 12 */
		11, /* RBX → struct index 11 */
		-1, /* RSP — read from VMCS   */
		10, /* RBP → struct index 10  */
		9,  /* RSI → struct index 9   */
		8,  /* RDI → struct index 8   */
		7,  /* R8  → struct index 7   */
		6,  /* R9  → struct index 6   */
		5,  /* R10 → struct index 5   */
		4,  /* R11 → struct index 4   */
		3,  /* R12 → struct index 3   */
		2,  /* R13 → struct index 2   */
		1,  /* R14 → struct index 1   */
		0,  /* R15 → struct index 0   */
	};
	if (idx < 0 || idx > 15)
		return 0;
	if (map[idx] < 0)
		return vmcs_readl(VMCS_GUEST_RSP);
	return r[map[idx]];
}

static void handle_cpuid(struct guest_regs *regs)
{
	u32 eax = (u32)regs->rax;
	u32 ecx = (u32)regs->rcx;

	asm volatile("cpuid"
		: "=a"(regs->rax), "=b"(regs->rbx),
		  "=c"(regs->rcx), "=d"(regs->rdx)
		: "a"(eax), "c"(ecx));

	advance_rip();
}

static void handle_cr_access(struct guest_regs *regs)
{
	unsigned long qual = vmcs_readl(VMCS_EXIT_QUAL);
	int cr_num  = QUAL_CR_NUM(qual);
	int cr_type = QUAL_CR_TYPE(qual);
	int reg_idx = QUAL_CR_REG(qual);

	if (cr_num != 4 || cr_type != CR_ACCESS_MOV_TO)
		goto resume; /* not a MOV-to-CR4, skip */

	{
		unsigned long new_cr4 = reg_value(regs, reg_idx);

		if (!(new_cr4 & X86_CR4_SMEP)) {
			atomic64_inc(&g_smep_blocks);
			pr_warn("[hv] CPU%d: SMEP disable blocked! "
				"(CR4 0x%lx → 0x%lx forced back to 0x%lx)\n",
				smp_processor_id(),
				vmcs_readl(VMCS_GUEST_CR4),
				new_cr4,
				new_cr4 | X86_CR4_SMEP);
			new_cr4 |= X86_CR4_SMEP;
		}

		/* Update guest CR4 in VMCS — do NOT touch host CR4 here.
		 * Writing host CR4 during VM-exit handling is wrong in nested VMX
		 * and unnecessary on bare metal (host CR4 is loaded from VMCS on exit). */
		vmcs_writel(VMCS_GUEST_CR4, new_cr4);
		vmcs_writel(VMCS_CR4_READ_SHADOW, new_cr4);
	}

resume:
	advance_rip();
}

static void handle_xsetbv(struct guest_regs *regs)
{
	u32 xcr = (u32)regs->rcx;
	u64 val = (regs->rdx << 32) | (u32)regs->rax;
	asm volatile("xsetbv" : : "c"(xcr), "A"(val));
	advance_rip();
}

asmlinkage void handle_vmexit(struct guest_regs *regs)
{
	u32 reason = vmcs_read32(VMCS_EXIT_REASON) & 0xffff;

	switch (reason) {
	case EXIT_REASON_CPUID:
		handle_cpuid(regs);
		break;
	case EXIT_REASON_CR_ACCESS:
		handle_cr_access(regs);
		break;
	case EXIT_REASON_INVD:
		asm volatile("wbinvd");
		advance_rip();
		break;
	case EXIT_REASON_XSETBV:
		handle_xsetbv(regs);
		break;
	case EXIT_REASON_HLT:
		/* Let the guest HLT — just advance RIP and it will loop */
		advance_rip();
		break;
	default:
		/* For any other exit, advance RIP and resume.
		 * A real hypervisor would handle each case; for this demo
		 * this is sufficient.
		 */
		advance_rip();
		break;
	}
}

asmlinkage void handle_vmresume_failure(void)
{
	u32 err = vmcs_read32(VMCS_INSN_ERROR);
	pr_err("[hv] VMRESUME failed! VM-instruction error: %u\n", err);
	/* Cannot recover — the system will hang on the jmp in entry.S */
}

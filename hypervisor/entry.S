/* SPDX-License-Identifier: GPL-2.0 */
/*
 * entry.S — VM-exit handler entry point and VMLAUNCH helper
 *
 * Stack layout after all pushes (lowest addr = RSP first):
 *   r15, r14, r13, r12, r11, r10, r9, r8, rdi, rsi, rbp, rbx, rdx, rcx, rax
 */

#include <linux/linkage.h>
#include <asm/asm.h>

/* ------------------------------------------------------------------ */
/* vmexit_entry: called by CPU on every VM-exit (HOST_RIP in VMCS)    */
/*                                                                      */
/* At entry, interrupts are disabled and RSP = HOST_RSP from VMCS      */
/* (which we set to stack_top - 8, so 15 pushes → 16-byte aligned RSP) */
/* ------------------------------------------------------------------ */
SYM_FUNC_START(vmexit_entry)
	pushq	%rax
	pushq	%rcx
	pushq	%rdx
	pushq	%rbx
	pushq	%rbp
	pushq	%rsi
	pushq	%rdi
	pushq	%r8
	pushq	%r9
	pushq	%r10
	pushq	%r11
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15

	/* RSP now points to struct guest_regs — pass as first argument */
	movq	%rsp, %rdi
	callq	handle_vmexit

	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	popq	%r11
	popq	%r10
	popq	%r9
	popq	%r8
	popq	%rdi
	popq	%rsi
	popq	%rbp
	popq	%rbx
	popq	%rdx
	popq	%rcx
	popq	%rax

	vmresume

	/* VMRESUME failed — should never happen in a working demo */
	pushq	$0
	callq	handle_vmresume_failure
0:	jmp	0b
SYM_FUNC_END(vmexit_entry)


/* ------------------------------------------------------------------ */
/* vmx_launch: set GUEST_RIP/RSP/RFLAGS and execute VMLAUNCH          */
/*                                                                      */
/* Called from C:  int vmx_launch(void);                               */
/*   Returns 0 on success (continuing as guest), -1 on failure.        */
/*                                                                      */
/* Strategy: set GUEST_RIP = guest_resume_point (label below).         */
/* After VMLAUNCH, guest resumes there, executes `ret`, and returns    */
/* to the original C caller as if vmx_launch() returned 0.             */
/* ------------------------------------------------------------------ */
SYM_FUNC_START(vmx_launch)
	/* GUEST_RIP = address of guest_resume_point */
	leaq	guest_resume_point(%rip), %rax
	movq	$0x681E, %rcx		/* VMCS_GUEST_RIP */
	vmwrite	%rax, %rcx

	/* GUEST_RSP = current RSP (top of stack has our caller's return addr) */
	movq	%rsp, %rax
	movq	$0x681C, %rcx		/* VMCS_GUEST_RSP */
	vmwrite	%rax, %rcx

	/* GUEST_RFLAGS = current RFLAGS (pushfq/popq net-zero on RSP) */
	pushfq
	popq	%rax
	orq	$(1 << 1), %rax		/* ensure reserved bit 1 is set */
	andq	$~(1 << 17), %rax	/* clear VM flag */
	movq	$0x6820, %rcx		/* VMCS_GUEST_RFLAGS */
	vmwrite	%rax, %rcx

	vmlaunch

	/* VMLAUNCH failed: return -1 */
	movq	$-1, %rax
	RET

guest_resume_point:
	/* Running as guest after successful VMLAUNCH: return 0 */
	xorq	%rax, %rax
	RET
SYM_FUNC_END(vmx_launch)

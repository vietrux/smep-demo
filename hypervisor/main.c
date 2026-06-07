// SPDX-License-Identifier: GPL-2.0
/*
 * main.c — SMEP-protection hypervisor: module entry/exit
 *
 * Demo flow:
 *   insmod hypervisor.ko  → virtualizes all CPUs, pins CR4.SMEP
 *   insmod attack.ko      → attempt to clear SMEP is blocked and logged
 *   rmmod  hypervisor.ko  → de-virtualizes all CPUs
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/smp.h>
#include <linux/percpu.h>
#include <linux/atomic.h>

#include "vmx.h"

DEFINE_PER_CPU(struct vcpu, vcpu_data);

static int cpu_errors;

/* Called on each CPU by on_each_cpu() */
static void init_cpu(void *info)
{
	struct vcpu *vcpu = this_cpu_ptr(&vcpu_data);
	int ret;

	ret = vmx_cpu_enable();
	if (ret) {
		atomic_inc((atomic_t *)info);
		return;
	}

	ret = vmcs_setup(vcpu);
	if (ret) {
		vmx_cpu_disable();
		atomic_inc((atomic_t *)info);
		return;
	}

	ret = vmx_launch();
	if (ret != 0) {
		pr_err("[hv] VMLAUNCH failed on CPU %d (error %d)\n",
		       smp_processor_id(), ret);
		vmx_cpu_disable();
		atomic_inc((atomic_t *)info);
		return;
	}

	/* If we reach here, we are now running as a guest */
	pr_info("[hv] CPU %d virtualized, SMEP protection active\n",
		smp_processor_id());
}

static void exit_cpu(void *info)
{
	vmx_cpu_disable();
}

static int __init hypervisor_init(void)
{
	atomic_t errors = ATOMIC_INIT(0);

	g_vcpu = &vcpu_data;

	pr_info("[hv] Loading SMEP-protection hypervisor\n");
	pr_info("[hv] Current CR4: 0x%lx (SMEP=%d)\n",
		hv_read_cr4(),
		!!(hv_read_cr4() & X86_CR4_SMEP));

	on_each_cpu(init_cpu, &errors, 1);

	cpu_errors = atomic_read(&errors);
	if (cpu_errors) {
		pr_err("[hv] %d CPU(s) failed to virtualize\n", cpu_errors);
		on_each_cpu(exit_cpu, NULL, 1);
		return -EIO;
	}

	pr_info("[hv] All CPUs virtualized. SMEP is now hypervisor-protected.\n");
	return 0;
}

static void __exit hypervisor_exit(void)
{
	pr_info("[hv] Unloading hypervisor (total SMEP blocks: %lld)\n",
		atomic64_read(&g_smep_blocks));
	on_each_cpu(exit_cpu, NULL, 1);
	pr_info("[hv] All CPUs de-virtualized\n");
}

module_init(hypervisor_init);
module_exit(hypervisor_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Thesis Demo");
MODULE_DESCRIPTION("Thin VT-x hypervisor protecting CR4.SMEP from kernel-level attacks");

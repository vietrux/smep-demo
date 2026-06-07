#ifndef VMX_H
#define VMX_H

#include <linux/types.h>

/* ------------------------------------------------------------------ */
/* VMCS field encodings (Intel SDM Vol 3C, Appendix B)                */
/* ------------------------------------------------------------------ */

/* 16-bit guest fields */
#define VMCS_GUEST_ES_SEL        0x0800
#define VMCS_GUEST_CS_SEL        0x0802
#define VMCS_GUEST_SS_SEL        0x0804
#define VMCS_GUEST_DS_SEL        0x0806
#define VMCS_GUEST_FS_SEL        0x0808
#define VMCS_GUEST_GS_SEL        0x080A
#define VMCS_GUEST_LDTR_SEL      0x080C
#define VMCS_GUEST_TR_SEL        0x080E

/* 16-bit host fields */
#define VMCS_HOST_ES_SEL         0x0C00
#define VMCS_HOST_CS_SEL         0x0C02
#define VMCS_HOST_SS_SEL         0x0C04
#define VMCS_HOST_DS_SEL         0x0C06
#define VMCS_HOST_FS_SEL         0x0C08
#define VMCS_HOST_GS_SEL         0x0C0A
#define VMCS_HOST_TR_SEL         0x0C0C

/* 64-bit control fields */
#define VMCS_MSR_BITMAP          0x2004

/* 64-bit guest fields */
#define VMCS_LINK_POINTER        0x2800
#define VMCS_GUEST_DEBUGCTL      0x2802
#define VMCS_GUEST_EFER          0x2806

/* 64-bit host fields */
#define VMCS_HOST_EFER           0x2C02

/* 32-bit control fields */
#define VMCS_PIN_EXEC_CTRL       0x4000
#define VMCS_PRI_EXEC_CTRL       0x4002
#define VMCS_EXCEPTION_BITMAP    0x4004
#define VMCS_EXIT_CTRL           0x400C
#define VMCS_ENTRY_CTRL          0x4012
#define VMCS_ENTRY_INTR_INFO     0x4016
#define VMCS_SEC_EXEC_CTRL       0x401E

/* 32-bit read-only fields */
#define VMCS_INSN_ERROR          0x4400
#define VMCS_EXIT_REASON         0x4402
#define VMCS_EXIT_INTR_INFO      0x4404
#define VMCS_EXIT_INSN_LEN       0x440C

/* 32-bit guest fields */
#define VMCS_GUEST_ES_LIMIT      0x4800
#define VMCS_GUEST_CS_LIMIT      0x4802
#define VMCS_GUEST_SS_LIMIT      0x4804
#define VMCS_GUEST_DS_LIMIT      0x4806
#define VMCS_GUEST_FS_LIMIT      0x4808
#define VMCS_GUEST_GS_LIMIT      0x480A
#define VMCS_GUEST_LDTR_LIMIT    0x480C
#define VMCS_GUEST_TR_LIMIT      0x480E
#define VMCS_GUEST_GDTR_LIMIT    0x4810
#define VMCS_GUEST_IDTR_LIMIT    0x4812
#define VMCS_GUEST_ES_AR         0x4814
#define VMCS_GUEST_CS_AR         0x4816
#define VMCS_GUEST_SS_AR         0x4818
#define VMCS_GUEST_DS_AR         0x481A
#define VMCS_GUEST_FS_AR         0x481C
#define VMCS_GUEST_GS_AR         0x481E
#define VMCS_GUEST_LDTR_AR       0x4820
#define VMCS_GUEST_TR_AR         0x4822
#define VMCS_GUEST_INTR_STATE    0x4824
#define VMCS_GUEST_ACTIVITY      0x4826
#define VMCS_GUEST_SYSENTER_CS   0x482A

/* 32-bit host fields */
#define VMCS_HOST_SYSENTER_CS    0x4C00

/* Natural-width control fields */
#define VMCS_CR0_GUEST_MASK      0x6000
#define VMCS_CR4_GUEST_MASK      0x6002
#define VMCS_CR0_READ_SHADOW     0x6004
#define VMCS_CR4_READ_SHADOW     0x6006

/* Natural-width read-only fields */
#define VMCS_EXIT_QUAL           0x6400

/* Natural-width guest fields */
#define VMCS_GUEST_CR0           0x6800
#define VMCS_GUEST_CR3           0x6802
#define VMCS_GUEST_CR4           0x6804
#define VMCS_GUEST_ES_BASE       0x6806
#define VMCS_GUEST_CS_BASE       0x6808
#define VMCS_GUEST_SS_BASE       0x680A
#define VMCS_GUEST_DS_BASE       0x680C
#define VMCS_GUEST_FS_BASE       0x680E
#define VMCS_GUEST_GS_BASE       0x6810
#define VMCS_GUEST_LDTR_BASE     0x6812
#define VMCS_GUEST_TR_BASE       0x6814
#define VMCS_GUEST_GDTR_BASE     0x6816
#define VMCS_GUEST_IDTR_BASE     0x6818
#define VMCS_GUEST_DR7           0x681A
#define VMCS_GUEST_RSP           0x681C
#define VMCS_GUEST_RIP           0x681E
#define VMCS_GUEST_RFLAGS        0x6820
#define VMCS_GUEST_PENDING_DBG   0x6822
#define VMCS_GUEST_SYSENTER_ESP  0x6824
#define VMCS_GUEST_SYSENTER_EIP  0x6826

/* Natural-width host fields */
#define VMCS_HOST_CR0            0x6C00
#define VMCS_HOST_CR3            0x6C02
#define VMCS_HOST_CR4            0x6C04
#define VMCS_HOST_FS_BASE        0x6C06
#define VMCS_HOST_GS_BASE        0x6C08
#define VMCS_HOST_TR_BASE        0x6C0A
#define VMCS_HOST_GDTR_BASE      0x6C0C
#define VMCS_HOST_IDTR_BASE      0x6C0E
#define VMCS_HOST_SYSENTER_ESP   0x6C10
#define VMCS_HOST_SYSENTER_EIP   0x6C12
#define VMCS_HOST_RSP            0x6C14
#define VMCS_HOST_RIP            0x6C16

/* ------------------------------------------------------------------ */
/* VM-exit reasons                                                      */
/* ------------------------------------------------------------------ */
#define EXIT_REASON_CPUID        10
#define EXIT_REASON_HLT          12
#define EXIT_REASON_INVD         13
#define EXIT_REASON_VMCALL       18
#define EXIT_REASON_CR_ACCESS    28
#define EXIT_REASON_RDMSR        31
#define EXIT_REASON_WRMSR        32
#define EXIT_REASON_XSETBV       55

/* Exit qualification for CR access */
#define QUAL_CR_NUM(q)    ((q) & 0xf)
#define QUAL_CR_TYPE(q)   (((q) >> 4) & 0x3)
#define QUAL_CR_REG(q)    (((q) >> 8) & 0xf)
#define CR_ACCESS_MOV_TO  0

/* ------------------------------------------------------------------ */
/* MSR indices                                                          */
/* ------------------------------------------------------------------ */
#define MSR_VMX_BASIC            0x480
#define MSR_VMX_PINBASED         0x481
#define MSR_VMX_PROCBASED        0x482
#define MSR_VMX_EXIT             0x483
#define MSR_VMX_ENTRY            0x484
#define MSR_VMX_CR0_FIXED0       0x486
#define MSR_VMX_CR0_FIXED1       0x487
#define MSR_VMX_CR4_FIXED0       0x488
#define MSR_VMX_CR4_FIXED1       0x489
#define MSR_VMX_PROCBASED2       0x48B
#define MSR_VMX_TRUE_PINBASED    0x48D
#define MSR_VMX_TRUE_PROCBASED   0x48E
#define MSR_VMX_TRUE_EXIT        0x48F
#define MSR_VMX_TRUE_ENTRY       0x490
#define MSR_FEATURE_CONTROL      0x3A
/* MSR_IA32_SYSENTER_CS/ESP/EIP, MSR_EFER, MSR_FS_BASE,
 * MSR_GS_BASE, MSR_KERNEL_GS_BASE — use kernel's <asm/msr-index.h> names */

/* IA32_FEATURE_CONTROL bits */
#define FEATURE_CTRL_LOCKED              BIT(0)
#define FEATURE_CTRL_VMXON_OUTSIDE_SMX   BIT(2)

/* ------------------------------------------------------------------ */
/* Pin-based VM-execution controls                                      */
/* ------------------------------------------------------------------ */
#define PIN_EXT_INTR_MASK    BIT(0)
#define PIN_NMI_EXITING      BIT(3)
#define PIN_VIRT_NMI         BIT(5)

/* ------------------------------------------------------------------ */
/* Primary CPU-based VM-execution controls                             */
/* ------------------------------------------------------------------ */
#define PRI_USE_MSR_BITMAPS  BIT(28)
#define PRI_ACTIVATE_SEC     BIT(31)

/* ------------------------------------------------------------------ */
/* Secondary CPU-based VM-execution controls                           */
/* ------------------------------------------------------------------ */
#define SEC_RDTSCP           BIT(3)
#define SEC_INVPCID          BIT(12)
#define SEC_XSAVES           BIT(20)

/* ------------------------------------------------------------------ */
/* VM-exit controls                                                     */
/* ------------------------------------------------------------------ */
#define VMEXIT_HOST_64BIT    BIT(9)
#define VMEXIT_SAVE_EFER     BIT(20)
#define VMEXIT_LOAD_EFER     BIT(21)

/* ------------------------------------------------------------------ */
/* VM-entry controls                                                    */
/* ------------------------------------------------------------------ */
#define VMENTRY_IA32E_GUEST  BIT(9)
#define VMENTRY_LOAD_EFER    BIT(15)

/* ------------------------------------------------------------------ */
/* Structures                                                           */
/* ------------------------------------------------------------------ */

#define VMXON_SIZE  4096
#define VMCS_SIZE   4096
#define HOST_STACK_SIZE (4 * PAGE_SIZE)

struct vmxon_region {
	u32 revision_id;
	u8  data[VMXON_SIZE - 4];
} __attribute__((packed, aligned(4096)));

struct vmcs_region {
	u32 revision_id;
	u32 abort_code;
	u8  data[VMCS_SIZE - 8];
} __attribute__((packed, aligned(4096)));

/* Per-CPU state for the hypervisor */
struct vcpu {
	struct vmxon_region *vmxon;
	phys_addr_t          vmxon_pa;
	struct vmcs_region  *vmcs;
	phys_addr_t          vmcs_pa;
	void                *msr_bitmap;   /* 4KB zeroed = no MSR exits */
	phys_addr_t          msr_bitmap_pa;
	void                *host_stack;
	u64                  host_rsp;     /* = top of host_stack - 8 */
};

/*
 * entry.S pushes rax first (→ highest addr, RSP+112) and r15 last
 * (→ lowest addr, RSP+0).  Field order must match the stack so that
 * offset 0 == r15 and offset 112 == rax.
 */
struct guest_regs {
	u64 r15;  /* RSP+0   — last pushed  */
	u64 r14;
	u64 r13;
	u64 r12;
	u64 r11;
	u64 r10;
	u64 r9;
	u64 r8;
	u64 rdi;
	u64 rsi;
	u64 rbp;
	u64 rbx;
	u64 rdx;
	u64 rcx;
	u64 rax;  /* RSP+112 — first pushed */
};

extern struct vcpu __percpu *g_vcpu;
extern atomic64_t g_smep_blocks;

/* ------------------------------------------------------------------ */
/* CR register helpers (direct asm — avoid unexported native_*() fns) */
/* ------------------------------------------------------------------ */

static __always_inline unsigned long hv_read_cr0(void)
{
	unsigned long v;
	asm volatile("mov %%cr0, %0" : "=r"(v));
	return v;
}

static __always_inline void hv_write_cr0(unsigned long v)
{
	asm volatile("mov %0, %%cr0" : : "r"(v) : "memory");
}

static __always_inline unsigned long hv_read_cr3(void)
{
	unsigned long v;
	asm volatile("mov %%cr3, %0" : "=r"(v));
	return v;
}

static __always_inline unsigned long hv_read_cr4(void)
{
	unsigned long v;
	asm volatile("mov %%cr4, %0" : "=r"(v));
	return v;
}

static __always_inline void hv_write_cr4(unsigned long v)
{
	asm volatile("mov %0, %%cr4" : : "r"(v) : "memory");
}

/* ------------------------------------------------------------------ */
/* VMCS inline read/write helpers                                       */
/* ------------------------------------------------------------------ */

static __always_inline unsigned long vmcs_readl(unsigned long field)
{
	unsigned long val;
	asm volatile("vmread %1, %0\n\t"
		     : "=r"(val) : "r"(field) : "cc");
	return val;
}

static __always_inline u32 vmcs_read32(unsigned long field)
{
	return (u32)vmcs_readl(field);
}

static __always_inline void vmcs_writel(unsigned long field, unsigned long val)
{
	asm volatile("vmwrite %1, %0\n\t"
		     : : "r"(field), "rm"(val) : "cc");
}

static __always_inline void vmcs_write32(unsigned long field, u32 val)
{
	vmcs_writel(field, val);
}

static __always_inline void vmcs_write64(unsigned long field, u64 val)
{
	vmcs_writel(field, val);
}

static __always_inline void vmcs_write16(unsigned long field, u16 val)
{
	vmcs_writel(field, val);
}

/* ------------------------------------------------------------------ */
/* Functions declared elsewhere                                         */
/* ------------------------------------------------------------------ */

/* entry.S */
asmlinkage void vmexit_entry(void);
asmlinkage int  vmx_launch(void);

/* vmx.c */
int  vmx_cpu_enable(void);
void vmx_cpu_disable(void);
u32  vmx_adjust_ctrl(u32 desired, u32 msr);

/* vmcs.c */
int vmcs_setup(struct vcpu *vcpu);

/* vmexit.c */
asmlinkage void handle_vmexit(struct guest_regs *regs);
asmlinkage void handle_vmresume_failure(void);

#endif /* VMX_H */

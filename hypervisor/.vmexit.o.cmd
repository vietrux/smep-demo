savedcmd_vmexit.o := gcc-13 -Wp,-MMD,./.vmexit.o.d -nostdinc -I/usr/src/linux-headers-6.14.0-37-generic/arch/x86/include -I/usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/generated -I/usr/src/linux-headers-6.14.0-37-generic/include -I/usr/src/linux-headers-6.14.0-37-generic/include -I/usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/uapi -I/usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/generated/uapi -I/usr/src/linux-headers-6.14.0-37-generic/include/uapi -I/usr/src/linux-headers-6.14.0-37-generic/include/generated/uapi -include /usr/src/linux-headers-6.14.0-37-generic/include/linux/compiler-version.h -include /usr/src/linux-headers-6.14.0-37-generic/include/linux/kconfig.h -I/usr/src/linux-headers-6.14.0-37-generic/ubuntu/include -include /usr/src/linux-headers-6.14.0-37-generic/include/linux/compiler_types.h -D__KERNEL__ -std=gnu11 -fshort-wchar -funsigned-char -fno-common -fno-PIE -fno-strict-aliasing -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -fcf-protection=none -m64 -falign-jumps=1 -falign-loops=1 -mno-80387 -mno-fp-ret-in-387 -mpreferred-stack-boundary=3 -mskip-rax-setup -mtune=generic -mno-red-zone -mcmodel=kernel -Wno-sign-compare -fno-asynchronous-unwind-tables -mindirect-branch=thunk-extern -mindirect-branch-register -mindirect-branch-cs-prefix -mfunction-return=thunk-extern -fno-jump-tables -mharden-sls=all -fpatchable-function-entry=16,16 -fno-delete-null-pointer-checks -O2 -fno-allow-store-data-races -fstack-protector-strong -fno-omit-frame-pointer -fno-optimize-sibling-calls -ftrivial-auto-var-init=zero -fno-stack-clash-protection -fzero-call-used-regs=used-gpr -pg -mrecord-mcount -mfentry -DCC_USING_FENTRY -falign-functions=16 -fstrict-flex-arrays=3 -fno-strict-overflow -fno-stack-check -fconserve-stack -fno-builtin-wcslen -Wall -Wextra -Wundef -Werror=implicit-function-declaration -Werror=implicit-int -Werror=return-type -Werror=strict-prototypes -Wno-format-security -Wno-trigraphs -Wno-frame-address -Wno-address-of-packed-member -Wmissing-declarations -Wmissing-prototypes -Wframe-larger-than=1024 -Wno-main -Wno-dangling-pointer -Wvla -Wno-pointer-sign -Wcast-function-type -Wno-array-bounds -Wno-stringop-overflow -Wno-alloc-size-larger-than -Wimplicit-fallthrough=5 -Werror=date-time -Werror=incompatible-pointer-types -Werror=designated-init -Wenum-conversion -Wunused -Wno-unused-but-set-variable -Wno-unused-const-variable -Wno-packed-not-aligned -Wno-format-overflow -Wno-format-truncation -Wno-stringop-truncation -Wno-override-init -Wno-missing-field-initializers -Wno-type-limits -Wno-shift-negative-value -Wno-maybe-uninitialized -Wno-sign-compare -Wno-unused-parameter -g -gdwarf-5 -I./.  -fsanitize=bounds-strict -fsanitize=shift -fsanitize=bool -fsanitize=enum    -DMODULE  -DKBUILD_BASENAME='"vmexit"' -DKBUILD_MODNAME='"hypervisor"' -D__KBUILD_MODNAME=kmod_hypervisor -c -o vmexit.o vmexit.c   ; /usr/src/linux-headers-6.14.0-37-generic/tools/objtool/objtool --hacks=jump_label --hacks=noinstr --hacks=skylake --retpoline --rethunk --sls --stackval --static-call --uaccess --prefix=16   --module vmexit.o

source_vmexit.o := vmexit.c

deps_vmexit.o := \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/compiler-version.h \
    $(wildcard include/config/CC_VERSION_TEXT) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/kconfig.h \
    $(wildcard include/config/CPU_BIG_ENDIAN) \
    $(wildcard include/config/BOOGER) \
    $(wildcard include/config/FOO) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/compiler_types.h \
    $(wildcard include/config/DEBUG_INFO_BTF) \
    $(wildcard include/config/PAHOLE_HAS_BTF_TAG) \
    $(wildcard include/config/FUNCTION_ALIGNMENT) \
    $(wildcard include/config/CC_HAS_SANE_FUNCTION_ALIGNMENT) \
    $(wildcard include/config/X86_64) \
    $(wildcard include/config/ARM64) \
    $(wildcard include/config/LD_DEAD_CODE_DATA_ELIMINATION) \
    $(wildcard include/config/LTO_CLANG) \
    $(wildcard include/config/HAVE_ARCH_COMPILER_H) \
    $(wildcard include/config/CC_HAS_COUNTED_BY) \
    $(wildcard include/config/UBSAN_SIGNED_WRAP) \
    $(wildcard include/config/CC_HAS_ASM_INLINE) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/compiler_attributes.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/compiler-gcc.h \
    $(wildcard include/config/MITIGATION_RETPOLINE) \
    $(wildcard include/config/ARCH_USE_BUILTIN_BSWAP) \
    $(wildcard include/config/SHADOW_CALL_STACK) \
    $(wildcard include/config/KCOV) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/kernel.h \
    $(wildcard include/config/PREEMPT_VOLUNTARY_BUILD) \
    $(wildcard include/config/PREEMPT_DYNAMIC) \
    $(wildcard include/config/HAVE_PREEMPT_DYNAMIC_CALL) \
    $(wildcard include/config/HAVE_PREEMPT_DYNAMIC_KEY) \
    $(wildcard include/config/PREEMPT_) \
    $(wildcard include/config/DEBUG_ATOMIC_SLEEP) \
    $(wildcard include/config/SMP) \
    $(wildcard include/config/MMU) \
    $(wildcard include/config/PROVE_LOCKING) \
    $(wildcard include/config/TRACING) \
    $(wildcard include/config/FTRACE_MCOUNT_RECORD) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/stdarg.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/align.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/const.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/vdso/const.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/linux/const.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/array_size.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/compiler.h \
    $(wildcard include/config/TRACE_BRANCH_PROFILING) \
    $(wildcard include/config/PROFILE_ALL_BRANCHES) \
    $(wildcard include/config/OBJTOOL) \
    $(wildcard include/config/64BIT) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/generated/asm/rwonce.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/rwonce.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/kasan-checks.h \
    $(wildcard include/config/KASAN_GENERIC) \
    $(wildcard include/config/KASAN_SW_TAGS) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/types.h \
    $(wildcard include/config/HAVE_UID16) \
    $(wildcard include/config/UID16) \
    $(wildcard include/config/ARCH_DMA_ADDR_T_64BIT) \
    $(wildcard include/config/PHYS_ADDR_T_64BIT) \
    $(wildcard include/config/ARCH_32BIT_USTAT_F_TINODE) \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/linux/types.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/generated/uapi/asm/types.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/asm-generic/types.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/int-ll64.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/asm-generic/int-ll64.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/uapi/asm/bitsperlong.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/bitsperlong.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/asm-generic/bitsperlong.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/linux/posix_types.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/stddef.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/linux/stddef.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/posix_types.h \
    $(wildcard include/config/X86_32) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/uapi/asm/posix_types_64.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/asm-generic/posix_types.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/kcsan-checks.h \
    $(wildcard include/config/KCSAN) \
    $(wildcard include/config/KCSAN_WEAK_MEMORY) \
    $(wildcard include/config/KCSAN_IGNORE_ATOMICS) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/limits.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/linux/limits.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/vdso/limits.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/linkage.h \
    $(wildcard include/config/ARCH_USE_SYM_ANNOTATIONS) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/stringify.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/export.h \
    $(wildcard include/config/MODVERSIONS) \
    $(wildcard include/config/GENDWARFKSYMS) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/linkage.h \
    $(wildcard include/config/CALL_PADDING) \
    $(wildcard include/config/MITIGATION_RETHUNK) \
    $(wildcard include/config/MITIGATION_SLS) \
    $(wildcard include/config/FUNCTION_PADDING_BYTES) \
    $(wildcard include/config/UML) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/ibt.h \
    $(wildcard include/config/X86_KERNEL_IBT) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/container_of.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/build_bug.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/bitops.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/bits.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/vdso/bits.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/linux/bits.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/typecheck.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/linux/kernel.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/linux/sysinfo.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/bitops/generic-non-atomic.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/barrier.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/alternative.h \
    $(wildcard include/config/CALL_THUNKS) \
    $(wildcard include/config/MITIGATION_ITS) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/objtool.h \
    $(wildcard include/config/FRAME_POINTER) \
    $(wildcard include/config/NOINSTR_VALIDATION) \
    $(wildcard include/config/MITIGATION_UNRET_ENTRY) \
    $(wildcard include/config/MITIGATION_SRSO) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/objtool_types.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/asm.h \
    $(wildcard include/config/KPROBES) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/extable_fixup_types.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/bug.h \
    $(wildcard include/config/GENERIC_BUG) \
    $(wildcard include/config/DEBUG_BUGVERBOSE) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/instrumentation.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/bug.h \
    $(wildcard include/config/BUG) \
    $(wildcard include/config/GENERIC_BUG_RELATIVE_POINTERS) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/once_lite.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/panic.h \
    $(wildcard include/config/PANIC_TIMEOUT) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/printk.h \
    $(wildcard include/config/MESSAGE_LOGLEVEL_DEFAULT) \
    $(wildcard include/config/CONSOLE_LOGLEVEL_DEFAULT) \
    $(wildcard include/config/CONSOLE_LOGLEVEL_QUIET) \
    $(wildcard include/config/EARLY_PRINTK) \
    $(wildcard include/config/PRINTK) \
    $(wildcard include/config/PRINTK_INDEX) \
    $(wildcard include/config/DYNAMIC_DEBUG) \
    $(wildcard include/config/DYNAMIC_DEBUG_CORE) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/init.h \
    $(wildcard include/config/MEMORY_HOTPLUG) \
    $(wildcard include/config/HAVE_ARCH_PREL32_RELOCATIONS) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/kern_levels.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/ratelimit_types.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/linux/param.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/generated/uapi/asm/param.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/param.h \
    $(wildcard include/config/HZ) \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/asm-generic/param.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/spinlock_types_raw.h \
    $(wildcard include/config/DEBUG_SPINLOCK) \
    $(wildcard include/config/DEBUG_LOCK_ALLOC) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/spinlock_types.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/qspinlock_types.h \
    $(wildcard include/config/NR_CPUS) \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/qrwlock_types.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/uapi/asm/byteorder.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/byteorder/little_endian.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/linux/byteorder/little_endian.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/swab.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/linux/swab.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/uapi/asm/swab.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/byteorder/generic.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/lockdep_types.h \
    $(wildcard include/config/PROVE_RAW_LOCK_NESTING) \
    $(wildcard include/config/LOCKDEP) \
    $(wildcard include/config/LOCK_STAT) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/dynamic_debug.h \
    $(wildcard include/config/JUMP_LABEL) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/jump_label.h \
    $(wildcard include/config/HAVE_ARCH_JUMP_LABEL_RELATIVE) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/cleanup.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/jump_label.h \
    $(wildcard include/config/HAVE_JUMP_LABEL_HACK) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/nops.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/barrier.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/bitops.h \
    $(wildcard include/config/X86_CMOV) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/rmwcc.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/args.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/bitops/sched.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/arch_hweight.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/cpufeatures.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/required-features.h \
    $(wildcard include/config/X86_MINIMUM_CPU_FAMILY) \
    $(wildcard include/config/MATH_EMULATION) \
    $(wildcard include/config/X86_PAE) \
    $(wildcard include/config/X86_CMPXCHG64) \
    $(wildcard include/config/X86_P6_NOP) \
    $(wildcard include/config/MATOM) \
    $(wildcard include/config/PARAVIRT_XXL) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/disabled-features.h \
    $(wildcard include/config/X86_UMIP) \
    $(wildcard include/config/X86_INTEL_MEMORY_PROTECTION_KEYS) \
    $(wildcard include/config/X86_5LEVEL) \
    $(wildcard include/config/MITIGATION_PAGE_TABLE_ISOLATION) \
    $(wildcard include/config/MITIGATION_CALL_DEPTH_TRACKING) \
    $(wildcard include/config/ADDRESS_MASKING) \
    $(wildcard include/config/INTEL_IOMMU_SVM) \
    $(wildcard include/config/X86_SGX) \
    $(wildcard include/config/XEN_PV) \
    $(wildcard include/config/INTEL_TDX_GUEST) \
    $(wildcard include/config/X86_USER_SHADOW_STACK) \
    $(wildcard include/config/X86_FRED) \
    $(wildcard include/config/KVM_AMD_SEV) \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/bitops/const_hweight.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/bitops/instrumented-atomic.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/instrumented.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/kmsan-checks.h \
    $(wildcard include/config/KMSAN) \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/bitops/instrumented-non-atomic.h \
    $(wildcard include/config/KCSAN_ASSUME_PLAIN_WRITES_ATOMIC) \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/bitops/instrumented-lock.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/bitops/le.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/bitops/ext2-atomic-setbit.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/hex.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/kstrtox.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/log2.h \
    $(wildcard include/config/ARCH_HAS_ILOG2_U32) \
    $(wildcard include/config/ARCH_HAS_ILOG2_U64) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/math.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/div64.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/div64.h \
    $(wildcard include/config/CC_OPTIMIZE_FOR_PERFORMANCE) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/minmax.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/sprintf.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/static_call_types.h \
    $(wildcard include/config/HAVE_STATIC_CALL) \
    $(wildcard include/config/HAVE_STATIC_CALL_INLINE) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/instruction_pointer.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/wordpart.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/atomic.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/atomic.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/cmpxchg.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/cmpxchg_64.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/atomic64_64.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/atomic/atomic-arch-fallback.h \
    $(wildcard include/config/GENERIC_ATOMIC64) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/atomic/atomic-long.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/atomic/atomic-instrumented.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/smp.h \
    $(wildcard include/config/UP_LATE_INIT) \
    $(wildcard include/config/DEBUG_PREEMPT) \
    $(wildcard include/config/CSD_LOCK_WAIT_DEBUG) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/errno.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/linux/errno.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/generated/uapi/asm/errno.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/asm-generic/errno.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/asm-generic/errno-base.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/list.h \
    $(wildcard include/config/LIST_HARDENED) \
    $(wildcard include/config/DEBUG_LIST) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/poison.h \
    $(wildcard include/config/ILLEGAL_POINTER_VALUE) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/cpumask.h \
    $(wildcard include/config/FORCE_NR_CPUS) \
    $(wildcard include/config/HOTPLUG_CPU) \
    $(wildcard include/config/DEBUG_PER_CPU_MAPS) \
    $(wildcard include/config/CPUMASK_OFFSTACK) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/bitmap.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/find.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/string.h \
    $(wildcard include/config/BINARY_PRINTF) \
    $(wildcard include/config/FORTIFY_SOURCE) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/err.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/overflow.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/linux/string.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/string.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/string_64.h \
    $(wildcard include/config/ARCH_HAS_UACCESS_FLUSHCACHE) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/fortify-string.h \
    $(wildcard include/config/CC_HAS_KASAN_MEMINTRINSIC_PREFIX) \
    $(wildcard include/config/GENERIC_ENTRY) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/bitfield.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/bug.h \
    $(wildcard include/config/BUG_ON_DATA_CORRUPTION) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/bitmap-str.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/cpumask_types.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/threads.h \
    $(wildcard include/config/BASE_SMALL) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/gfp_types.h \
    $(wildcard include/config/KASAN_HW_TAGS) \
    $(wildcard include/config/SLAB_OBJ_EXT) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/numa.h \
    $(wildcard include/config/NODES_SHIFT) \
    $(wildcard include/config/NUMA_KEEP_MEMINFO) \
    $(wildcard include/config/NUMA) \
    $(wildcard include/config/HAVE_ARCH_NODE_DEV_GROUP) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/sparsemem.h \
    $(wildcard include/config/SPARSEMEM) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/smp_types.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/llist.h \
    $(wildcard include/config/ARCH_HAVE_NMI_SAFE_CMPXCHG) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/preempt.h \
    $(wildcard include/config/PREEMPT_RT) \
    $(wildcard include/config/PREEMPT_COUNT) \
    $(wildcard include/config/TRACE_PREEMPT_TOGGLE) \
    $(wildcard include/config/PREEMPTION) \
    $(wildcard include/config/PREEMPT_NOTIFIERS) \
    $(wildcard include/config/PREEMPT_NONE) \
    $(wildcard include/config/PREEMPT_VOLUNTARY) \
    $(wildcard include/config/PREEMPT) \
    $(wildcard include/config/PREEMPT_LAZY) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/preempt.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/percpu.h \
    $(wildcard include/config/X86_64_SMP) \
    $(wildcard include/config/CC_HAS_NAMED_AS) \
    $(wildcard include/config/USE_X86_SEG_SUPPORT) \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/percpu.h \
    $(wildcard include/config/HAVE_SETUP_PER_CPU_AREA) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/percpu-defs.h \
    $(wildcard include/config/DEBUG_FORCE_WEAK_PER_CPU) \
    $(wildcard include/config/AMD_MEM_ENCRYPT) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/current.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/cache.h \
    $(wildcard include/config/ARCH_HAS_CACHE_LINE_SIZE) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/cache.h \
    $(wildcard include/config/X86_L1_CACHE_SHIFT) \
    $(wildcard include/config/X86_INTERNODE_CACHE_SHIFT) \
    $(wildcard include/config/X86_VSMP) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/thread_info.h \
    $(wildcard include/config/THREAD_INFO_IN_TASK) \
    $(wildcard include/config/ARCH_HAS_PREEMPT_LAZY) \
    $(wildcard include/config/HAVE_ARCH_WITHIN_STACK_FRAMES) \
    $(wildcard include/config/HARDENED_USERCOPY) \
    $(wildcard include/config/SH) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/restart_block.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/thread_info.h \
    $(wildcard include/config/VM86) \
    $(wildcard include/config/X86_IOPL_IOPERM) \
    $(wildcard include/config/COMPAT) \
    $(wildcard include/config/IA32_EMULATION) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/page.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/page_types.h \
    $(wildcard include/config/PHYSICAL_START) \
    $(wildcard include/config/PHYSICAL_ALIGN) \
    $(wildcard include/config/DYNAMIC_PHYSICAL_MASK) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/mem_encrypt.h \
    $(wildcard include/config/ARCH_HAS_MEM_ENCRYPT) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/mem_encrypt.h \
    $(wildcard include/config/X86_MEM_ENCRYPT) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/cc_platform.h \
    $(wildcard include/config/ARCH_HAS_CC_PLATFORM) \
  /usr/src/linux-headers-6.14.0-37-generic/include/vdso/page.h \
    $(wildcard include/config/PAGE_SHIFT) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/page_64_types.h \
    $(wildcard include/config/KASAN) \
    $(wildcard include/config/DYNAMIC_MEMORY_LAYOUT) \
    $(wildcard include/config/RANDOMIZE_BASE) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/kaslr.h \
    $(wildcard include/config/RANDOMIZE_MEMORY) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/page_64.h \
    $(wildcard include/config/DEBUG_VIRTUAL) \
    $(wildcard include/config/X86_VSYSCALL_EMULATION) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/range.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/memory_model.h \
    $(wildcard include/config/FLATMEM) \
    $(wildcard include/config/SPARSEMEM_VMEMMAP) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/pfn.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/getorder.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/cpufeature.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/processor.h \
    $(wildcard include/config/X86_VMX_FEATURE_NAMES) \
    $(wildcard include/config/STACKPROTECTOR) \
    $(wildcard include/config/CPU_SUP_AMD) \
    $(wildcard include/config/XEN) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/processor-flags.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/uapi/asm/processor-flags.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/math_emu.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/ptrace.h \
    $(wildcard include/config/PARAVIRT) \
    $(wildcard include/config/X86_DEBUGCTLMSR) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/segment.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/uapi/asm/ptrace.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/uapi/asm/ptrace-abi.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/paravirt_types.h \
    $(wildcard include/config/PGTABLE_LEVELS) \
    $(wildcard include/config/ZERO_CALL_USED_REGS) \
    $(wildcard include/config/PARAVIRT_DEBUG) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/desc_defs.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/pgtable_types.h \
    $(wildcard include/config/MEM_SOFT_DIRTY) \
    $(wildcard include/config/HAVE_ARCH_USERFAULTFD_WP) \
    $(wildcard include/config/PROC_FS) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/pgtable_64_types.h \
    $(wildcard include/config/DEBUG_KMAP_LOCAL_FORCE_MAP) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/nospec-branch.h \
    $(wildcard include/config/CALL_THUNKS_DEBUG) \
    $(wildcard include/config/MITIGATION_IBPB_ENTRY) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/static_key.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/msr-index.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/unwind_hints.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/orc_types.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/asm-offsets.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/generated/asm-offsets.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/GEN-for-each-reg.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/proto.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/uapi/asm/ldt.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/uapi/asm/sigcontext.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/cpuid.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/paravirt.h \
    $(wildcard include/config/PARAVIRT_SPINLOCKS) \
    $(wildcard include/config/DEBUG_ENTRY) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/frame.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/special_insns.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/irqflags.h \
    $(wildcard include/config/TRACE_IRQFLAGS) \
    $(wildcard include/config/IRQSOFF_TRACER) \
    $(wildcard include/config/PREEMPT_TRACER) \
    $(wildcard include/config/DEBUG_IRQFLAGS) \
    $(wildcard include/config/TRACE_IRQFLAGS_SUPPORT) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/irqflags_types.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/irqflags.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/fpu/types.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/vmxfeatures.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/vdso/processor.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/shstk.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/personality.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/uapi/linux/personality.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/math64.h \
    $(wildcard include/config/ARCH_SUPPORTS_INT128) \
  /usr/src/linux-headers-6.14.0-37-generic/include/vdso/math64.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/smp.h \
    $(wildcard include/config/DEBUG_NMI_SELFTEST) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/cpumask.h \
  vmx.h \

vmexit.o: $(deps_vmexit.o)

$(deps_vmexit.o):

vmexit.o: $(wildcard /usr/src/linux-headers-6.14.0-37-generic/tools/objtool/objtool)

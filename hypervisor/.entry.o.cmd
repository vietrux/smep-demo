savedcmd_entry.o := gcc-13 -Wp,-MMD,./.entry.o.d -nostdinc -I/usr/src/linux-headers-6.14.0-37-generic/arch/x86/include -I/usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/generated -I/usr/src/linux-headers-6.14.0-37-generic/include -I/usr/src/linux-headers-6.14.0-37-generic/include -I/usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/uapi -I/usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/generated/uapi -I/usr/src/linux-headers-6.14.0-37-generic/include/uapi -I/usr/src/linux-headers-6.14.0-37-generic/include/generated/uapi -include /usr/src/linux-headers-6.14.0-37-generic/include/linux/compiler-version.h -include /usr/src/linux-headers-6.14.0-37-generic/include/linux/kconfig.h -I/usr/src/linux-headers-6.14.0-37-generic/ubuntu/include -D__KERNEL__ -D__ASSEMBLY__ -fno-PIE -m64 -DCC_USING_FENTRY -g -gdwarf-5  -DMODULE  -DKBUILD_MODNAME='"hypervisor"' -D__KBUILD_MODNAME=kmod_hypervisor -c -o entry.o entry.S 

source_entry.o := entry.S

deps_entry.o := \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/compiler-version.h \
    $(wildcard include/config/CC_VERSION_TEXT) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/kconfig.h \
    $(wildcard include/config/CPU_BIG_ENDIAN) \
    $(wildcard include/config/BOOGER) \
    $(wildcard include/config/FOO) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/linkage.h \
    $(wildcard include/config/FUNCTION_ALIGNMENT) \
    $(wildcard include/config/ARCH_USE_SYM_ANNOTATIONS) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/compiler_types.h \
    $(wildcard include/config/DEBUG_INFO_BTF) \
    $(wildcard include/config/PAHOLE_HAS_BTF_TAG) \
    $(wildcard include/config/CC_HAS_SANE_FUNCTION_ALIGNMENT) \
    $(wildcard include/config/X86_64) \
    $(wildcard include/config/ARM64) \
    $(wildcard include/config/LD_DEAD_CODE_DATA_ELIMINATION) \
    $(wildcard include/config/LTO_CLANG) \
    $(wildcard include/config/HAVE_ARCH_COMPILER_H) \
    $(wildcard include/config/CC_HAS_COUNTED_BY) \
    $(wildcard include/config/UBSAN_SIGNED_WRAP) \
    $(wildcard include/config/CC_HAS_ASM_INLINE) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/stringify.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/export.h \
    $(wildcard include/config/MODVERSIONS) \
    $(wildcard include/config/64BIT) \
    $(wildcard include/config/GENDWARFKSYMS) \
  /usr/src/linux-headers-6.14.0-37-generic/include/linux/compiler.h \
    $(wildcard include/config/TRACE_BRANCH_PROFILING) \
    $(wildcard include/config/PROFILE_ALL_BRANCHES) \
    $(wildcard include/config/OBJTOOL) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/generated/asm/rwonce.h \
  /usr/src/linux-headers-6.14.0-37-generic/include/asm-generic/rwonce.h \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/linkage.h \
    $(wildcard include/config/X86_32) \
    $(wildcard include/config/CALL_PADDING) \
    $(wildcard include/config/MITIGATION_RETHUNK) \
    $(wildcard include/config/MITIGATION_RETPOLINE) \
    $(wildcard include/config/MITIGATION_SLS) \
    $(wildcard include/config/FUNCTION_PADDING_BYTES) \
    $(wildcard include/config/UML) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/ibt.h \
    $(wildcard include/config/X86_KERNEL_IBT) \
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
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/asm.h \
    $(wildcard include/config/KPROBES) \
  /usr/src/linux-headers-6.14.0-37-generic/arch/x86/include/asm/extable_fixup_types.h \

entry.o: $(deps_entry.o)

$(deps_entry.o):

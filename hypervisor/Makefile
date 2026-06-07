KDIR ?= /lib/modules/$(shell uname -r)/build

obj-m := hypervisor.o
hypervisor-objs := main.o vmx.o vmcs.o vmexit.o entry.o

ccflags-y := -I$(src)

# entry.S is intentionally non-standard: VMLAUNCH transfers control to
# guest_resume_point via the VMCS GUEST_RIP, not a CALL instruction.
# Objtool cannot validate this pattern; skip it.
OBJECT_FILES_NON_STANDARD_entry.o := y

all:
	$(MAKE) -C $(KDIR) M=$(CURDIR) modules

clean:
	$(MAKE) -C $(KDIR) M=$(CURDIR) clean

.PHONY: all clean

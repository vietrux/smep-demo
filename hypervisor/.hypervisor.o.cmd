savedcmd_hypervisor.o := ld -m elf_x86_64 -z noexecstack --no-warn-rwx-segments   -r -o hypervisor.o @hypervisor.mod 

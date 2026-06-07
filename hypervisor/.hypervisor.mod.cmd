savedcmd_hypervisor.mod := printf '%s\n'   main.o vmx.o vmcs.o vmexit.o entry.o | awk '!x[$$0]++ { print("./"$$0) }' > hypervisor.mod

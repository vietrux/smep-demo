savedcmd_attack.mod := printf '%s\n'   attack.o | awk '!x[$$0]++ { print("./"$$0) }' > attack.mod

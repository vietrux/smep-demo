## Recreate VM from scratch

---

### Prerequisites — files needed

```bash
ls ~/vm-images/
```
Must have:
- `smep-fresh.qcow2` — main disk (Debian 12)
- `smep-demo-vars.fd` — UEFI vars copy
- `cloud-init.iso` — first-boot config (user: demo/demo)

If `smep-fresh.qcow2` missing, copy from original:
```bash
cp ~/vm-images/debian12.qcow2 ~/vm-images/smep-fresh.qcow2
```

---

### Step 1: Grant permissions to libvirt

Run once (needed so libvirt can read files in `/home/dev/`):

```bash
setfacl -R -m u:libvirt-qemu:rx ~/vm-images/
setfacl -m u:libvirt-qemu:x ~/
```

---

### Step 2: Enable nested VMX (required for hypervisor.ko to work)

```bash
echo 'options kvm-intel nested=1' | sudo tee /etc/modprobe.d/kvm-intel.conf
sudo modprobe -r kvm-intel && sudo modprobe kvm-intel
# Verify:
cat /sys/module/kvm_intel/parameters/nested   # must print Y
```

---

### Step 3: Create VM with virt-install

```bash
virt-install \
  --connect qemu:///system \
  --name smep-demo \
  --memory 2048 \
  --vcpus 2 \
  --cpu host-passthrough \
  --os-variant debian12 \
  --disk path=/home/dev/vm-images/smep-fresh.qcow2,format=qcow2,bus=virtio \
  --cdrom /home/dev/vm-images/cloud-init.iso \
  --network network=default,model=virtio \
  --graphics spice \
  --video qxl \
  --boot uefi \
  --boot loader=/usr/share/OVMF/OVMF_CODE_4M.fd,loader.readonly=yes,loader.type=pflash,nvram.template=/usr/share/OVMF/OVMF_VARS_4M.fd \
  --noautoconsole \
  --import
```

> If `--boot uefi` conflicts with `--boot loader=...`, remove the `--boot uefi` line and keep only `--boot loader=...`

---

### Step 4: Wait for VM to boot (~30–60s)

```bash
virsh --connect qemu:///system list --all
# Should show: smep-demo   running
```

---

### Step 5: Fix network in VM (every boot)

Get VM console via virt-manager (double-click `smep-demo`), log in:
```
login: demo
password: demo
```

Then:
```bash
sudo dhclient enp1s0
ip addr show enp1s0   # verify got 192.168.122.xxx
```

---

### Step 6: Copy source code into VM

On **host terminal**:
```bash
# Get VM IP
virsh --connect qemu:///system net-dhcp-leases default

# Copy source (replace IP with actual)
scp -r ~/Workspaces/03_Academic_Projects/research-hypervisor/smep-demo demo@192.168.122.252:~/
```

---

### Step 7: Build modules inside VM

SSH into VM:
```bash
ssh demo@192.168.122.252
cd ~/smep-demo
make
```

Expected: `hypervisor/hypervisor.ko` and `attack/attack.ko` created.

---

### Step 8: Run demo

Follow `smep-demo/DEMO_GUIDE.md` — or short version:

```bash
# Phase 1: no hypervisor
sudo insmod ~/smep-demo/attack/attack.ko
sleep 1 && sudo rmmod attack
sudo dmesg   # → SMEP=0, attack succeeded

# Phase 2: load hypervisor
sudo insmod ~/smep-demo/hypervisor/hypervisor.ko
sudo dmesg   # → all CPUs virtualized

# Phase 3: attack again
sudo insmod ~/smep-demo/attack/attack.ko
sleep 1 && sudo rmmod attack
sudo dmesg   # → SMEP still ON, hypervisor blocked!
```

---

### Troubleshooting

| Problem | Fix |
|---------|-----|
| VM not in virt-manager | Run `virt-install` command above |
| `smep-demo` already exists but broken | `virsh --connect qemu:///system undefine smep-demo --remove-all-storage` then redo |
| Permission denied on disk | Re-run `setfacl` commands |
| VMXON failed in VM | `cat /sys/module/kvm_intel/parameters/nested` must be `Y` |
| No `vmx` in `/proc/cpuinfo` inside VM | VM CPU must be `host-passthrough`, not `kvm64` |
| Network DOWN after reboot | Always run `sudo dhclient enp1s0` after login |
| SSH "no route to host" | `dhclient` not run yet, or VM still booting |

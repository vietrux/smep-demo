# SMEP Hypervisor Demo Guide
## Thesis: Protecting CR4.SMEP with a Thin VT-x Hypervisor

---

## Concept (Explain to Teacher)

**The problem:**
An attacker with kernel-level code execution (e.g., via a kernel exploit) can execute:
```c
asm volatile("mov %0, %%cr4" : : "r"(cr4 & ~X86_CR4_SMEP));
```
This clears CR4 bit 20 (SMEP), disabling Supervisor Mode Execution Prevention.
Without SMEP, the kernel can execute user-space memory → enables **ret2usr** attacks.

**The defense:**
A thin hypervisor sits *below* the OS using Intel VT-x (hardware virtualization).
It sets `CR4_GUEST_HOST_MASK = SMEP` in the VMCS, meaning:
- The hypervisor *owns* the SMEP bit
- Any guest (OS) attempt to write CR4 with SMEP=0 triggers a **VM-exit**
- The hypervisor intercepts the write, forces SMEP=1 back, and resumes
- The OS never knows the write was blocked

**Why this works:**
The protection runs at a privilege level *below ring 0* (VMX root mode).
A kernel-level attacker cannot bypass it without first removing the hypervisor,
which requires the hypervisor's own cooperation.

---

## VM Setup

The demo runs inside a KVM virtual machine (Debian 12, kernel 6.1.0-49-amd64).
This is valid because the advisor (tandasat) uses the same nested VM approach.

### Step 1: Open virt-manager

Open **Virtual Machine Manager** from the applications menu.
You should see `smep-demo` listed. Double-click to open the console.

### Step 2: Log in

```
login: demo
password: demo
```

### Step 3: Fix network (required every boot)

The network interface does not auto-start. Run:
```bash
sudo dhclient enp1s0
```

Wait 3-5 seconds. Verify:
```bash
ip addr show enp1s0
```
You should see `inet 192.168.122.xxx`.

### Step 4: Navigate to demo directory

```bash
cd ~/smep-demo
ls
```

You should see: `hypervisor/  attack/  Makefile`

### Step 5: Build modules (only needed if not already built)

```bash
make
```

Expected output ends with: `LD [M] hypervisor/hypervisor.ko` and `LD [M] attack/attack.ko`

---

## Demo Sequence

### PHASE 1 — Attack WITHOUT Hypervisor (Baseline)

**Goal:** Show that a kernel module can disable SMEP freely.

```bash
# Check SMEP is currently ON
sudo dmesg -C
grep 'smep' /proc/cpuinfo | head -1
```
Expected: CPU flags include `smep`.

```bash
# Load the attack module
sudo insmod attack/attack.ko

# Wait 1 second, then unload
sleep 1 && sudo rmmod attack

# Read the kernel log
sudo dmesg
```

**Expected output:**
```
[attack] CR4 before write: 0x370ef0  (SMEP=1)
[attack] Attempting to write CR4 = 0x270ef0 (SMEP cleared)...
[attack] CR4 after  write: 0x270ef0  (SMEP=0)
[attack] RESULT: SMEP is OFF — attack succeeded (no hypervisor)!
```

**Explain:** CR4 went from `0x370ef0` (bit 20 set = SMEP on) to `0x270ef0`
(bit 20 clear = SMEP off). The OS could not protect itself.

---

### PHASE 2 — Load Hypervisor

**Goal:** Put the OS into a VM. The hypervisor now owns CR4.SMEP.

```bash
sudo dmesg -C
sudo insmod hypervisor/hypervisor.ko
sudo dmesg
```

**Expected output:**
```
[hv] Loading SMEP-protection hypervisor
[hv] Current CR4: 0x...  (SMEP=...)
[hv] VMXON success on CPU 0
[hv] VMXON success on CPU 1
[hv] VMCS configured on CPU 0 (SMEP protection active)
[hv] VMCS configured on CPU 1 (SMEP protection active)
[hv] CPU 0 virtualized, SMEP protection active
[hv] CPU 1 virtualized, SMEP protection active
[hv] All CPUs virtualized. SMEP is now hypervisor-protected.
```

**Explain:**
- `VMXON` = hardware VMX mode enabled (CPU is now in VMX root mode)
- `VMCS configured` = VMCS programmed with `CR4_GUEST_HOST_MASK = SMEP`
- `CPU N virtualized` = VMLAUNCH succeeded; OS now runs as a guest

The OS is still running normally — users see no difference.
But every CR4 write that touches SMEP will now trigger a VM-exit.

---

### PHASE 3 — Attack WITH Hypervisor (Protection Demo)

**Goal:** Show the hypervisor intercepts and blocks the attack.

```bash
sudo dmesg -C
sudo insmod attack/attack.ko
sleep 1 && sudo rmmod attack
sudo dmesg
```

**Expected output:**
```
[hv] CPU0: SMEP disable blocked! (CR4 0x370ef0 → 0x270ef0 forced back to 0x370ef0)
[attack] CR4 before write: 0x370ef0  (SMEP=1)
[attack] Attempting to write CR4 = 0x270ef0 (SMEP cleared)...
[attack] CR4 after  write: 0x370ef0  (SMEP=1)
[attack] RESULT: SMEP still ON — hypervisor blocked!
```

**Explain:**
1. Attack module executes `mov 0x270ef0, %cr4` (SMEP clear)
2. CPU triggers VM-exit (because SMEP bit changed vs. hypervisor's shadow)
3. Hypervisor handler runs in VMX root mode (ring -1)
4. Handler forces SMEP=1, writes corrected value to VMCS_GUEST_CR4
5. `vmresume` — OS continues, but CR4 has SMEP=1 still
6. Attack reads back CR4: SMEP is still 1 → blocked!

---

### PHASE 4 — Show Block Count and Unload

```bash
sudo rmmod hypervisor
sudo dmesg | grep hv
```

**Expected:**
```
[hv] Unloading hypervisor (total SMEP blocks: 1)
[hv] All CPUs de-virtualized
```

Total SMEP blocks = 1 (exactly the one attempt by attack.ko).

---

## What to Point at in Code

| File | Line | What to show |
|------|------|--------------|
| `hypervisor/vmcs.c` | ~177 | `VMCS_CR4_GUEST_MASK = X86_CR4_SMEP` — hypervisor owns SMEP bit |
| `hypervisor/vmcs.c` | ~179 | `READ_SHADOW = cr4 | SMEP` — guest always reads SMEP=1 |
| `hypervisor/vmexit.c` | ~handle_cr_access | VM-exit handler that intercepts and blocks |
| `attack/attack.c` | ~cr4 write | The attack: one line clears SMEP |

---

## Key Terms for Q&A

**SMEP** — Supervisor Mode Execution Prevention. CR4 bit 20. Prevents kernel
from executing code in user-space pages (stops ret2usr exploits).

**VMX root mode** — CPU privilege level below ring 0 used by hypervisors.
An attacker at ring 0 cannot reach VMX root mode without help from the hypervisor itself.

**VMCS** — Virtual Machine Control Structure. A hardware data structure that
controls what the guest (OS) can and cannot do. We use `CR4_GUEST_HOST_MASK`
to reserve the SMEP bit for the hypervisor.

**VM-exit** — An event where the guest stops and transfers control to the hypervisor.
Triggered here when the guest writes CR4 with a different SMEP bit than the shadow.

**Blue-pill** — Technique of inserting a hypervisor under a running OS without reboot.
We use VMLAUNCH with GUEST_RIP = current instruction pointer.

**CR4_READ_SHADOW** — What the guest *sees* when it reads CR4.
We set it to always show SMEP=1, so the OS thinks SMEP is on even while we protect it.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `insmod: ERROR: could not insert module` | Check `sudo dmesg` for reason |
| `VMXON failed` | Nested VMX not enabled. Run `cat /sys/module/kvm_intel/parameters/nested` — must be `Y` |
| `VMLAUNCH failed` | VMCS setup error. Check dmesg for which CPU |
| VM crashes on hypervisor load | Rebuild modules: `make clean && make` |
| SSH not working | Run `sudo dhclient enp1s0` first |
| No `smep` in cpuinfo | VM CPU model too old. Check VM settings in virt-manager |

---

## Architecture Diagram

```
┌─────────────────────────────────────┐
│          User Space (ring 3)        │
│    (normal programs, shell, etc.)   │
├─────────────────────────────────────┤
│         Linux Kernel (ring 0)       │  ← attacker is HERE
│   attack.ko: mov 0x270ef0, %cr4    │  ← tries to clear SMEP
├─────────────────────────────────────┤
│   VT-x Hardware (VMX root / ring-1) │  ← hypervisor.ko runs HERE
│                                     │
│  On CR4 write with SMEP=0:         │
│    VM-exit → handler intercepts     │
│    Forces SMEP=1 → vmresume        │
└─────────────────────────────────────┘
         ↑ attacker cannot reach this layer
```

---

## Demo Checklist

- [ ] VM visible in virt-manager
- [ ] Logged in as `demo`
- [ ] `sudo dhclient enp1s0` ran — interface UP
- [ ] `ls ~/smep-demo/` shows `hypervisor/` and `attack/` with `.ko` files
- [ ] Phase 1: `attack.ko` → SMEP OFF (baseline)
- [ ] Phase 2: `hypervisor.ko` → all CPUs virtualized
- [ ] Phase 3: `attack.ko` again → SMEP still ON (blocked!)
- [ ] Phase 4: `rmmod hypervisor` → shows block count = 1

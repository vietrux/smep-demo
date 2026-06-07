## Cách hypervisor bảo vệ SMEP — giải thích cho thầy

---

### Bối cảnh: Attacker ở ring 0

Giả sử attacker đã có **kernel code execution** (ring 0) — ví dụ qua lỗ hổng kernel.

Mục tiêu: tắt SMEP để thực thi ret2usr attack:
```c
// Attacker chạy lệnh này trong kernel
mov 0x270ef0, %cr4   // xóa bit 20 (SMEP) của CR4
```

**Không có hypervisor**: lệnh này chạy thẳng, SMEP tắt. Attacker thắng.

---

### Intel VT-x tạo ra một lớp bên dưới ring 0

```
┌──────────────────────────────────┐
│   ring 3  — user space           │
├──────────────────────────────────┤
│   ring 0  — Linux kernel         │  ← attacker ở đây
├══════════════════════════════════╡
│   VMX root — hypervisor          │  ← ta chạy ở đây (bên dưới ring 0)
└──────────────────────────────────┘
         hardware VT-x
```

VT-x tạo ra **VMX root mode** — đặc quyền cao hơn ring 0.
Attacker ở ring 0 **không thể** chạm tới VMX root mode.

---

### VMCS — bảng điều khiển phần cứng

Khi load `hypervisor.ko`:
1. **VMXON** — bật VMX hardware mode
2. **VMCS setup** — cấu hình bảng điều khiển VMCS:
   ```
   CR4_GUEST_HOST_MASK = SMEP   ← hypervisor "sở hữu" bit SMEP
   CR4_READ_SHADOW     = ...1.. ← OS đọc CR4 thấy SMEP=1
   ```
3. **VMLAUNCH** — bỏ OS vào trong VM (blue-pill)

OS vẫn chạy bình thường — **không biết mình đang trong VM**.

---

### Cơ chế bẫy (VM-exit)

CPU có quy tắc phần cứng:

> Nếu guest (OS) ghi CR4 với bit SMEP **khác** với `CR4_READ_SHADOW`,
> CPU **dừng guest** và chuyển quyền về hypervisor → gọi là **VM-exit**.

**Khi attacker chạy** `mov 0x270ef0, %cr4`:
- Bit SMEP trong giá trị mới = **0**
- Bit SMEP trong READ_SHADOW = **1**
- Khác nhau → **VM-exit!**

---

### Handler xử lý VM-exit

```c
void handle_cr_access(struct guest_regs *regs) {
    unsigned long new_cr4 = reg_value(regs, reg_idx); // đọc giá trị attacker muốn ghi

    if (!(new_cr4 & X86_CR4_SMEP)) {          // attacker muốn xóa SMEP?
        new_cr4 |= X86_CR4_SMEP;              // bật SMEP lại
        pr_warn("SMEP disable blocked!");
    }

    vmcs_writel(VMCS_GUEST_CR4, new_cr4);     // ghi CR4 cho OS (có SMEP=1)
    vmcs_writel(VMCS_CR4_READ_SHADOW, new_cr4);
    advance_rip();                             // bỏ qua lệnh ghi CR4
    // vmresume → OS tiếp tục chạy
}
```

**Kết quả**: OS tiếp tục chạy, nhưng CR4 có SMEP=1. Attacker không biết bị chặn.

---

### Timeline hoàn chỉnh

```
OS kernel (attacker):   mov 0x270ef0, %cr4
                                │
                     CPU phát hiện SMEP bit thay đổi
                                │
                            VM-exit
                                │
Hypervisor handler:     đọc giá trị → thấy SMEP=0
                        → ép SMEP=1
                        → ghi vào VMCS
                                │
                            vmresume
                                │
OS kernel:              lệnh ghi CR4 "hoàn thành"
                        đọc lại CR4 → thấy SMEP=1
                        → "bị chặn!"
```

---

### Tại sao attacker không bypass được?

| Câu hỏi | Trả lời |
|---------|---------|
| Sao không dùng `rmmod hypervisor`? | `rmmod` gọi `hypervisor_exit()` → cần hypervisor cho phép |
| Sao không tắt VMXE trong CR4? | CR4.VMXE cũng bị mask → tắt VMXE cũng gây VM-exit |
| Sao không dùng `VMXOFF`? | `VMXOFF` là privileged instruction, chỉ chạy được ở VMX root |
| Sao không viết thẳng vào VMCS? | VMCS chỉ accessible từ VMX root mode |

Hypervisor ở lớp dưới ring 0 → **attacker ở ring 0 bị giới hạn phần cứng, không thoát ra được**.

---

### Demo sequence cho thầy

| Bước | Lệnh | Kết quả mong đợi |
|------|------|-----------------|
| 1 | `insmod attack.ko` | **SMEP=0** — tấn công thành công (không có HV) |
| 2 | `rmmod attack` | — |
| 3 | `insmod hypervisor.ko` | VMXON + VMLAUNCH thành công, OS vào VM |
| 4 | `insmod attack.ko` | **SMEP=1** — bị chặn, hypervisor log "blocked!" |
| 5 | `rmmod hypervisor` | In tổng số lần chặn = 1 |

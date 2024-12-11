    .extern trap_handler
    .section .text.entry
    .align 2
    .globl _traps
    .extern dummy
    .globl __dummy
    .globl __switch_to

__switch_to:
    # save state to prev process
    addi t0, a0, 24
    sd ra, 8(t0)
    sd sp, 16(t0)
    sd s0, 24(t0)
    sd s1, 32(t0)
    sd s2, 40(t0)
    sd s3, 48(t0)
    sd s4, 56(t0)
    sd s5, 64(t0)
    sd s6, 72(t0)
    sd s7, 80(t0)
    sd s8, 88(t0)
    sd s9, 96(t0)
    sd s10, 104(t0)
    sd s11, 112(t0)

    # 保存其它的寄存器
    csrr t1, sepc
    sd t1, 120(t0)
    csrr t1, sstatus
    sd t1, 128(t0)
    csrr t1, sscratch
    sd t1, 136(t0)
    csrr t1, satp
    sd t1, 144(t0)

    # restore state from next process
    addi t0, a1, 24
    ld ra, 8(t0)
    ld sp, 16(t0)
    ld s0, 24(t0)
    ld s1, 32(t0)
    ld s2, 40(t0)
    ld s3, 48(t0)
    ld s4, 56(t0)
    ld s5, 64(t0)
    ld s6, 72(t0)
    ld s7, 80(t0)
    ld s8, 88(t0)
    ld s9, 96(t0)
    ld s10, 104(t0)
    ld s11, 112(t0)
    # 恢复其它寄存器
    ld t1, 120(t0)
    csrw sepc, t1
    ld t1, 128(t0)
    csrw sstatus, t1
    ld t1, 136(t0)
    csrw sscratch, t1
    ld t1, 144(t0)
    csrw satp, t1 # 修改satp就相当于更换页表（吗？）
    # flush tlb and ichache
    sfence.vma zero, zero

    ret

__dummy:
    # YOUR CODE HERE
    # 将 sepc 设置为 dummy() 的地址
    # la a0, dummy
    # csrw sepc, a0
    # 交换sscratch和sp的值
    csrr t0, sscratch
    csrw sscratch, sp
    mv sp, t0
    # li t0, 0
    # csrw sepc, t0 # 不知道要不要加
    sret

_traps:
    csrr t0, sscratch
    beq t0, x0, _no_swap
    csrw sscratch, sp
    mv sp, t0

_no_swap:
    # 1. save 32 registers and sepc to stack
    # 此处需要-33*8,因为还要储存spec
    addi sp, sp, -33*8
    sd zero, 0(sp)
    sd ra, 8(sp)
    sd sp, 16(sp)
    sd gp, 24(sp)
    sd tp, 32(sp)
    sd t0, 40(sp)
    sd t1, 48(sp)
    sd t2, 56(sp)
    sd fp, 64(sp)
    sd s1, 72(sp)
    sd a0, 80(sp)
    sd a1, 88(sp)
    sd a2, 96(sp)
    sd a3, 104(sp)
    sd a4, 112(sp)
    sd a5, 120(sp)
    sd a6, 128(sp)
    sd a7, 136(sp)
    sd t3, 144(sp)
    sd t4, 152(sp)
    sd t5, 160(sp)
    sd t6, 168(sp)
    sd s2, 176(sp)
    sd s3, 184(sp)
    sd s4, 192(sp)
    sd s5, 200(sp)
    sd s6, 208(sp)
    sd s7, 216(sp)
    sd s8, 224(sp)
    sd s9, 232(sp)
    sd s10, 240(sp)
    sd s11, 248(sp)
    csrr t0, sepc
    sd t0, 256(sp)

    # 2. call trap_handler
    csrr a0, scause
    csrr a1, sepc
    mv a2, sp // 把pt_regs传入trap_handler
    call trap_handler

    # 3. restore sepc and 32 registers (x2(sp) should be restored last) from stack
    ld t0, 256(sp)
    csrw sepc, t0
    ld zero, 0(sp)
    ld ra, 8(sp)
    ld sp, 16(sp)
    ld gp, 24(sp)
    ld tp, 32(sp)
    ld t0, 40(sp)
    ld t1, 48(sp)
    ld t2, 56(sp)
    ld fp, 64(sp)
    ld s1, 72(sp)
    ld a0, 80(sp)
    ld a1, 88(sp)
    ld a2, 96(sp)
    ld a3, 104(sp)
    ld a4, 112(sp)
    ld a5, 120(sp)
    ld a6, 128(sp)
    ld a7, 136(sp)
    ld t3, 144(sp)
    ld t4, 152(sp)
    ld t5, 160(sp)
    ld t6, 168(sp)
    ld s2, 176(sp)
    ld s3, 184(sp)
    ld s4, 192(sp)
    ld s5, 200(sp)
    ld s6, 208(sp)
    ld s7, 216(sp)
    ld s8, 224(sp)
    ld s9, 232(sp)
    ld s10, 240(sp)
    ld s11, 248(sp)
    addi sp, sp, 33*8 # 最后还原sp
    # 4. return from trap

    csrr t1, sscratch
    beq t1, zero, _end
    csrw sscratch,sp # 交换sscratch和sp
    mv sp,t1

_end:
    sret
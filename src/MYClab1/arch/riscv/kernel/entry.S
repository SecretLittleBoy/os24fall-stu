    .extern trap_handler
    .section .text.entry
    .align 2
    .globl _traps
_traps:
    # 1. save 32 registers and sepc to stack
    addi sp, sp, -32*8
    sd ra, 0(sp)
    sd sp, 8(sp)
    sd gp, 16(sp)
    sd tp, 24(sp)
    sd t0, 32(sp)
    sd t1, 40(sp)
    sd t2, 48(sp)
    sd s0, 56(sp)
    sd s1, 64(sp)
    sd s2, 72(sp)
    sd s3, 80(sp)
    sd s4, 88(sp)
    sd s5, 96(sp)
    sd s6, 104(sp)
    sd s7, 112(sp)
    sd s8, 120(sp)
    sd s9, 128(sp)
    sd s10, 136(sp)
    sd s11, 144(sp)
    sd a0, 152(sp)
    sd a1, 160(sp)
    sd a2, 168(sp)
    sd a3, 176(sp)
    sd a4, 184(sp)
    sd a5, 192(sp)
    sd a6, 200(sp)
    sd a7, 208(sp)
    sd t3, 216(sp)
    sd t4, 224(sp)
    sd t5, 232(sp)
    sd t6, 240(sp)

    csrr a0, scause
    csrr a1, sepc
    sd a0, 248(sp)
    sd a1, 256(sp)

    # 2. call trap_handler
    call trap_handler

    # 3. restore sepc and 32 registers (x2(sp) should be restored last) from stack
    ld a0, 248(sp)
    ld a1, 256(sp)
    csrw scause, a0
    csrw sepc, a1
    ld ra, 0(sp)
    ld gp, 16(sp)
    ld tp, 24(sp)
    ld t0, 32(sp)
    ld t1, 40(sp)
    ld t2, 48(sp)
    ld s0, 56(sp)
    ld s1, 64(sp)
    ld s2, 72(sp)
    ld s3, 80(sp)
    ld s4, 88(sp)
    ld s5, 96(sp)
    ld s6, 104(sp)
    ld s7, 112(sp)
    ld s8, 120(sp)
    ld s9, 128(sp)
    ld s10, 136(sp)
    ld s11, 144(sp)
    ld a0, 152(sp)
    ld a1, 160(sp)
    ld a2, 168(sp)
    ld a3, 176(sp)
    ld a4, 184(sp)
    ld a5, 192(sp)
    ld a6, 200(sp)
    ld a7, 208(sp)
    ld t3, 216(sp)
    ld t4, 224(sp)
    ld t5, 232(sp)
    ld t6, 240(sp)
    ld sp, 8(sp)
    addi sp, sp, 32*8
    # 4. return from trap
    sret               # 从中断返回
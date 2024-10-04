    .extern start_kernel
    .section .text.init
    .globl _start
_start:
    # (previous) initialize stack
    la a1, boot_stack_top
    lui t0, %hi(4096)
    addiw t0, t0, %lo(4096)
    add a1, a1, t0
    mv sp, a1
    # la sp, boot_stack_top
    # set stvec = _traps
    la t0, _traps
    csrw stvec, t0
    # set sie[STIE] = 1
    csrr t0, sie
    li t1, 1 << 5
    or t0, t0, t1
    csrw sie, t0
    # set first time interrupt
    rdtime a0
    .equ TIMECLOCK, 10000000
    li t2, TIMECLOCK
    add a0, a0, t2
    call sbi_set_timer

    # jal ra, clock_set_next_event


    # set sstatus[SIE] = 1
    csrr t0, sstatus
    li t1, 1 << 1
    or t0, t0, t1
    csrw sstatus, t0
    # (previous) jump to start_kernel
    # jalr zero, 0(ra)
    j start_kernel

    .section .bss.stack
    .globl boot_stack
boot_stack:
    .space 4096 # <-- change to your stack size

    .globl boot_stack_top
boot_stack_top:
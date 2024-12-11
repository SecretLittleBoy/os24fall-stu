    .extern start_kernel
    .extern _srodata
    .section .text.init
    .globl _start
_start:
    # (previous) initialize stack
    la sp, boot_stack_top

    call setup_vm # initialize virtual memory 
    call relocate
    call mm_init # initialize physical memory
    call setup_vm_final
    call task_init # initialize task threads

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
    # set sstatus[SIE] = 1
    # csrr t0, sstatus
    # li t1, 1 << 1
    # or t0, t0, t1
    # csrw sstatus, t0

    # (previous) jump to start_kernel
    jal start_kernel

    # .section .bss.stack
    # .globl boot_stack
relocate:
    # set ra = ra + PA2VA_OFFSET
    # set sp = sp + PA2VA_OFFSET (If you have set the sp before)
    li t0, 0xffffffdf80000000 # PA2VA_OFFSET
    add ra, ra, t0
    add sp, sp, t0

    # need a fence to ensure the new translations are in use
    sfence.vma zero, zero

    # set satp with early_pgtbl
    li t2, 0x8
    slli t2, t2, 60 # set mode = Sv39
    la t1, early_pgtbl
    srli t1, t1, 12 # PA>>12 = PPN
    or t1, t1, t2 # combine mode and page table
    csrw satp, t1

    ret

    .section .bss.stack
    .globl boot_stack
boot_stack:
    .space 4096 # <-- change to your stack size

    .globl boot_stack_top
boot_stack_top:
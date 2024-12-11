
../../vmlinux:     file format elf64-littleriscv


Disassembly of section .text:

ffffffe000200000 <_skernel>:
    .extern _srodata
    .section .text.init
    .globl _start
_start:
    # (previous) initialize stack
    la sp, boot_stack_top
ffffffe000200000:	00009117          	auipc	sp,0x9
ffffffe000200004:	00010113          	mv	sp,sp

    call setup_vm # initialize virtual memory 
ffffffe000200008:	0d8020ef          	jal	ffffffe0002020e0 <setup_vm>
    call relocate
ffffffe00020000c:	044000ef          	jal	ffffffe000200050 <relocate>
    call mm_init # initialize physical memory
ffffffe000200010:	269000ef          	jal	ffffffe000200a78 <mm_init>
    call setup_vm_final
ffffffe000200014:	1b4020ef          	jal	ffffffe0002021c8 <setup_vm_final>
    call task_init # initialize task threads
ffffffe000200018:	295000ef          	jal	ffffffe000200aac <task_init>

    # set stvec = _traps
    la t0, _traps
ffffffe00020001c:	00000297          	auipc	t0,0x0
ffffffe000200020:	13828293          	addi	t0,t0,312 # ffffffe000200154 <_traps>
    csrw stvec, t0
ffffffe000200024:	10529073          	csrw	stvec,t0
    # set sie[STIE] = 1
    csrr t0, sie
ffffffe000200028:	104022f3          	csrr	t0,sie
    li t1, 1 << 5
ffffffe00020002c:	02000313          	li	t1,32
    or t0, t0, t1
ffffffe000200030:	0062e2b3          	or	t0,t0,t1
    csrw sie, t0
ffffffe000200034:	10429073          	csrw	sie,t0
    # set first time interrupt
    rdtime a0
ffffffe000200038:	c0102573          	rdtime	a0
    .equ TIMECLOCK, 10000000
    li t2, TIMECLOCK
ffffffe00020003c:	009893b7          	lui	t2,0x989
ffffffe000200040:	6803839b          	addiw	t2,t2,1664 # 989680 <TIMECLOCK>
    add a0, a0, t2
ffffffe000200044:	00750533          	add	a0,a0,t2
    call sbi_set_timer
ffffffe000200048:	0b5010ef          	jal	ffffffe0002018fc <sbi_set_timer>
    # li t1, 1 << 1
    # or t0, t0, t1
    # csrw sstatus, t0

    # (previous) jump to start_kernel
    jal start_kernel
ffffffe00020004c:	5b4020ef          	jal	ffffffe000202600 <start_kernel>

ffffffe000200050 <relocate>:
    # .section .bss.stack
    # .globl boot_stack
relocate:
    # set ra = ra + PA2VA_OFFSET
    # set sp = sp + PA2VA_OFFSET (If you have set the sp before)
    li t0, 0xffffffdf80000000 # PA2VA_OFFSET
ffffffe000200050:	fbf0029b          	addiw	t0,zero,-65
ffffffe000200054:	01f29293          	slli	t0,t0,0x1f
    add ra, ra, t0
ffffffe000200058:	005080b3          	add	ra,ra,t0
    add sp, sp, t0
ffffffe00020005c:	00510133          	add	sp,sp,t0

    # need a fence to ensure the new translations are in use
    sfence.vma zero, zero
ffffffe000200060:	12000073          	sfence.vma

    # set satp with early_pgtbl
    li t2, 0x8
ffffffe000200064:	00800393          	li	t2,8
    slli t2, t2, 60 # set mode = Sv39
ffffffe000200068:	03c39393          	slli	t2,t2,0x3c
    la t1, early_pgtbl
ffffffe00020006c:	0000a317          	auipc	t1,0xa
ffffffe000200070:	f9430313          	addi	t1,t1,-108 # ffffffe00020a000 <early_pgtbl>
    srli t1, t1, 12 # PA>>12 = PPN
ffffffe000200074:	00c35313          	srli	t1,t1,0xc
    or t1, t1, t2 # combine mode and page table
ffffffe000200078:	00736333          	or	t1,t1,t2
    csrw satp, t1
ffffffe00020007c:	18031073          	csrw	satp,t1

    ret
ffffffe000200080:	00008067          	ret

ffffffe000200084 <__switch_to>:
    .globl __dummy
    .globl __switch_to

__switch_to:
    # save state to prev process
    addi t0, a0, 24
ffffffe000200084:	01850293          	addi	t0,a0,24
    sd ra, 8(t0)
ffffffe000200088:	0012b423          	sd	ra,8(t0)
    sd sp, 16(t0)
ffffffe00020008c:	0022b823          	sd	sp,16(t0)
    sd s0, 24(t0)
ffffffe000200090:	0082bc23          	sd	s0,24(t0)
    sd s1, 32(t0)
ffffffe000200094:	0292b023          	sd	s1,32(t0)
    sd s2, 40(t0)
ffffffe000200098:	0322b423          	sd	s2,40(t0)
    sd s3, 48(t0)
ffffffe00020009c:	0332b823          	sd	s3,48(t0)
    sd s4, 56(t0)
ffffffe0002000a0:	0342bc23          	sd	s4,56(t0)
    sd s5, 64(t0)
ffffffe0002000a4:	0552b023          	sd	s5,64(t0)
    sd s6, 72(t0)
ffffffe0002000a8:	0562b423          	sd	s6,72(t0)
    sd s7, 80(t0)
ffffffe0002000ac:	0572b823          	sd	s7,80(t0)
    sd s8, 88(t0)
ffffffe0002000b0:	0582bc23          	sd	s8,88(t0)
    sd s9, 96(t0)
ffffffe0002000b4:	0792b023          	sd	s9,96(t0)
    sd s10, 104(t0)
ffffffe0002000b8:	07a2b423          	sd	s10,104(t0)
    sd s11, 112(t0)
ffffffe0002000bc:	07b2b823          	sd	s11,112(t0)

    # 保存其它的寄存器
    csrr t1, sepc
ffffffe0002000c0:	14102373          	csrr	t1,sepc
    sd t1, 120(t0)
ffffffe0002000c4:	0662bc23          	sd	t1,120(t0)
    csrr t1, sstatus
ffffffe0002000c8:	10002373          	csrr	t1,sstatus
    sd t1, 128(t0)
ffffffe0002000cc:	0862b023          	sd	t1,128(t0)
    csrr t1, sscratch
ffffffe0002000d0:	14002373          	csrr	t1,sscratch
    sd t1, 136(t0)
ffffffe0002000d4:	0862b423          	sd	t1,136(t0)
    csrr t1, satp
ffffffe0002000d8:	18002373          	csrr	t1,satp
    sd t1, 144(t0)
ffffffe0002000dc:	0862b823          	sd	t1,144(t0)

    # restore state from next process
    addi t0, a1, 24
ffffffe0002000e0:	01858293          	addi	t0,a1,24
    ld ra, 8(t0)
ffffffe0002000e4:	0082b083          	ld	ra,8(t0)
    ld sp, 16(t0)
ffffffe0002000e8:	0102b103          	ld	sp,16(t0)
    ld s0, 24(t0)
ffffffe0002000ec:	0182b403          	ld	s0,24(t0)
    ld s1, 32(t0)
ffffffe0002000f0:	0202b483          	ld	s1,32(t0)
    ld s2, 40(t0)
ffffffe0002000f4:	0282b903          	ld	s2,40(t0)
    ld s3, 48(t0)
ffffffe0002000f8:	0302b983          	ld	s3,48(t0)
    ld s4, 56(t0)
ffffffe0002000fc:	0382ba03          	ld	s4,56(t0)
    ld s5, 64(t0)
ffffffe000200100:	0402ba83          	ld	s5,64(t0)
    ld s6, 72(t0)
ffffffe000200104:	0482bb03          	ld	s6,72(t0)
    ld s7, 80(t0)
ffffffe000200108:	0502bb83          	ld	s7,80(t0)
    ld s8, 88(t0)
ffffffe00020010c:	0582bc03          	ld	s8,88(t0)
    ld s9, 96(t0)
ffffffe000200110:	0602bc83          	ld	s9,96(t0)
    ld s10, 104(t0)
ffffffe000200114:	0682bd03          	ld	s10,104(t0)
    ld s11, 112(t0)
ffffffe000200118:	0702bd83          	ld	s11,112(t0)
    # 恢复其它寄存器
    ld t1, 120(t0)
ffffffe00020011c:	0782b303          	ld	t1,120(t0)
    csrw sepc, t1
ffffffe000200120:	14131073          	csrw	sepc,t1
    ld t1, 128(t0)
ffffffe000200124:	0802b303          	ld	t1,128(t0)
    csrw sstatus, t1
ffffffe000200128:	10031073          	csrw	sstatus,t1
    ld t1, 136(t0)
ffffffe00020012c:	0882b303          	ld	t1,136(t0)
    csrw sscratch, t1
ffffffe000200130:	14031073          	csrw	sscratch,t1
    ld t1, 144(t0)
ffffffe000200134:	0902b303          	ld	t1,144(t0)
    csrw satp, t1 # 修改satp就相当于更换页表（吗？）
ffffffe000200138:	18031073          	csrw	satp,t1
    # flush tlb and ichache
    sfence.vma zero, zero
ffffffe00020013c:	12000073          	sfence.vma

    ret
ffffffe000200140:	00008067          	ret

ffffffe000200144 <__dummy>:
    # YOUR CODE HERE
    # 将 sepc 设置为 dummy() 的地址
    # la a0, dummy
    # csrw sepc, a0
    # 交换sscratch和sp的值
    csrr t0, sscratch
ffffffe000200144:	140022f3          	csrr	t0,sscratch
    csrw sscratch, sp
ffffffe000200148:	14011073          	csrw	sscratch,sp
    mv sp, t0
ffffffe00020014c:	00028113          	mv	sp,t0
    # li t0, 0
    # csrw sepc, t0 # 不知道要不要加
    sret
ffffffe000200150:	10200073          	sret

ffffffe000200154 <_traps>:

_traps:
    csrr t0, sscratch
ffffffe000200154:	140022f3          	csrr	t0,sscratch
    beq t0, x0, _no_swap
ffffffe000200158:	00028663          	beqz	t0,ffffffe000200164 <_no_swap>
    csrw sscratch, sp
ffffffe00020015c:	14011073          	csrw	sscratch,sp
    mv sp, t0
ffffffe000200160:	00028113          	mv	sp,t0

ffffffe000200164 <_no_swap>:

_no_swap:
    # 1. save 32 registers and sepc to stack
    # 此处需要-33*8,因为还要储存spec
    addi sp, sp, -33*8
ffffffe000200164:	ef810113          	addi	sp,sp,-264 # ffffffe000208ef8 <_sbss+0xef8>
    sd zero, 0(sp)
ffffffe000200168:	00013023          	sd	zero,0(sp)
    sd ra, 8(sp)
ffffffe00020016c:	00113423          	sd	ra,8(sp)
    sd sp, 16(sp)
ffffffe000200170:	00213823          	sd	sp,16(sp)
    sd gp, 24(sp)
ffffffe000200174:	00313c23          	sd	gp,24(sp)
    sd tp, 32(sp)
ffffffe000200178:	02413023          	sd	tp,32(sp)
    sd t0, 40(sp)
ffffffe00020017c:	02513423          	sd	t0,40(sp)
    sd t1, 48(sp)
ffffffe000200180:	02613823          	sd	t1,48(sp)
    sd t2, 56(sp)
ffffffe000200184:	02713c23          	sd	t2,56(sp)
    sd fp, 64(sp)
ffffffe000200188:	04813023          	sd	s0,64(sp)
    sd s1, 72(sp)
ffffffe00020018c:	04913423          	sd	s1,72(sp)
    sd a0, 80(sp)
ffffffe000200190:	04a13823          	sd	a0,80(sp)
    sd a1, 88(sp)
ffffffe000200194:	04b13c23          	sd	a1,88(sp)
    sd a2, 96(sp)
ffffffe000200198:	06c13023          	sd	a2,96(sp)
    sd a3, 104(sp)
ffffffe00020019c:	06d13423          	sd	a3,104(sp)
    sd a4, 112(sp)
ffffffe0002001a0:	06e13823          	sd	a4,112(sp)
    sd a5, 120(sp)
ffffffe0002001a4:	06f13c23          	sd	a5,120(sp)
    sd a6, 128(sp)
ffffffe0002001a8:	09013023          	sd	a6,128(sp)
    sd a7, 136(sp)
ffffffe0002001ac:	09113423          	sd	a7,136(sp)
    sd t3, 144(sp)
ffffffe0002001b0:	09c13823          	sd	t3,144(sp)
    sd t4, 152(sp)
ffffffe0002001b4:	09d13c23          	sd	t4,152(sp)
    sd t5, 160(sp)
ffffffe0002001b8:	0be13023          	sd	t5,160(sp)
    sd t6, 168(sp)
ffffffe0002001bc:	0bf13423          	sd	t6,168(sp)
    sd s2, 176(sp)
ffffffe0002001c0:	0b213823          	sd	s2,176(sp)
    sd s3, 184(sp)
ffffffe0002001c4:	0b313c23          	sd	s3,184(sp)
    sd s4, 192(sp)
ffffffe0002001c8:	0d413023          	sd	s4,192(sp)
    sd s5, 200(sp)
ffffffe0002001cc:	0d513423          	sd	s5,200(sp)
    sd s6, 208(sp)
ffffffe0002001d0:	0d613823          	sd	s6,208(sp)
    sd s7, 216(sp)
ffffffe0002001d4:	0d713c23          	sd	s7,216(sp)
    sd s8, 224(sp)
ffffffe0002001d8:	0f813023          	sd	s8,224(sp)
    sd s9, 232(sp)
ffffffe0002001dc:	0f913423          	sd	s9,232(sp)
    sd s10, 240(sp)
ffffffe0002001e0:	0fa13823          	sd	s10,240(sp)
    sd s11, 248(sp)
ffffffe0002001e4:	0fb13c23          	sd	s11,248(sp)
    csrr t0, sepc
ffffffe0002001e8:	141022f3          	csrr	t0,sepc
    sd t0, 256(sp)
ffffffe0002001ec:	10513023          	sd	t0,256(sp)

    # 2. call trap_handler
    csrr a0, scause
ffffffe0002001f0:	14202573          	csrr	a0,scause
    csrr a1, sepc
ffffffe0002001f4:	141025f3          	csrr	a1,sepc
    mv a2, sp // 把pt_regs传入trap_handler
ffffffe0002001f8:	00010613          	mv	a2,sp
    call trap_handler
ffffffe0002001fc:	10d010ef          	jal	ffffffe000201b08 <trap_handler>

    # 3. restore sepc and 32 registers (x2(sp) should be restored last) from stack
    ld t0, 256(sp)
ffffffe000200200:	10013283          	ld	t0,256(sp)
    csrw sepc, t0
ffffffe000200204:	14129073          	csrw	sepc,t0
    ld zero, 0(sp)
ffffffe000200208:	00013003          	ld	zero,0(sp)
    ld ra, 8(sp)
ffffffe00020020c:	00813083          	ld	ra,8(sp)
    ld sp, 16(sp)
ffffffe000200210:	01013103          	ld	sp,16(sp)
    ld gp, 24(sp)
ffffffe000200214:	01813183          	ld	gp,24(sp)
    ld tp, 32(sp)
ffffffe000200218:	02013203          	ld	tp,32(sp)
    ld t0, 40(sp)
ffffffe00020021c:	02813283          	ld	t0,40(sp)
    ld t1, 48(sp)
ffffffe000200220:	03013303          	ld	t1,48(sp)
    ld t2, 56(sp)
ffffffe000200224:	03813383          	ld	t2,56(sp)
    ld fp, 64(sp)
ffffffe000200228:	04013403          	ld	s0,64(sp)
    ld s1, 72(sp)
ffffffe00020022c:	04813483          	ld	s1,72(sp)
    ld a0, 80(sp)
ffffffe000200230:	05013503          	ld	a0,80(sp)
    ld a1, 88(sp)
ffffffe000200234:	05813583          	ld	a1,88(sp)
    ld a2, 96(sp)
ffffffe000200238:	06013603          	ld	a2,96(sp)
    ld a3, 104(sp)
ffffffe00020023c:	06813683          	ld	a3,104(sp)
    ld a4, 112(sp)
ffffffe000200240:	07013703          	ld	a4,112(sp)
    ld a5, 120(sp)
ffffffe000200244:	07813783          	ld	a5,120(sp)
    ld a6, 128(sp)
ffffffe000200248:	08013803          	ld	a6,128(sp)
    ld a7, 136(sp)
ffffffe00020024c:	08813883          	ld	a7,136(sp)
    ld t3, 144(sp)
ffffffe000200250:	09013e03          	ld	t3,144(sp)
    ld t4, 152(sp)
ffffffe000200254:	09813e83          	ld	t4,152(sp)
    ld t5, 160(sp)
ffffffe000200258:	0a013f03          	ld	t5,160(sp)
    ld t6, 168(sp)
ffffffe00020025c:	0a813f83          	ld	t6,168(sp)
    ld s2, 176(sp)
ffffffe000200260:	0b013903          	ld	s2,176(sp)
    ld s3, 184(sp)
ffffffe000200264:	0b813983          	ld	s3,184(sp)
    ld s4, 192(sp)
ffffffe000200268:	0c013a03          	ld	s4,192(sp)
    ld s5, 200(sp)
ffffffe00020026c:	0c813a83          	ld	s5,200(sp)
    ld s6, 208(sp)
ffffffe000200270:	0d013b03          	ld	s6,208(sp)
    ld s7, 216(sp)
ffffffe000200274:	0d813b83          	ld	s7,216(sp)
    ld s8, 224(sp)
ffffffe000200278:	0e013c03          	ld	s8,224(sp)
    ld s9, 232(sp)
ffffffe00020027c:	0e813c83          	ld	s9,232(sp)
    ld s10, 240(sp)
ffffffe000200280:	0f013d03          	ld	s10,240(sp)
    ld s11, 248(sp)
ffffffe000200284:	0f813d83          	ld	s11,248(sp)
    addi sp, sp, 33*8 # 最后还原sp
ffffffe000200288:	10810113          	addi	sp,sp,264
    # 4. return from trap

    csrr t1, sscratch
ffffffe00020028c:	14002373          	csrr	t1,sscratch
    beq t1, zero, _end
ffffffe000200290:	00030663          	beqz	t1,ffffffe00020029c <_end>
    csrw sscratch,sp # 交换sscratch和sp
ffffffe000200294:	14011073          	csrw	sscratch,sp
    mv sp,t1
ffffffe000200298:	00030113          	mv	sp,t1

ffffffe00020029c <_end>:

_end:
ffffffe00020029c:	10200073          	sret

ffffffe0002002a0 <get_cycles>:
#include "printk.h"

// QEMU 中时钟的频率是 10MHz，也就是 1 秒钟相当于 10000000 个时钟周期
uint64_t TIMECLOCK = 10000000;

uint64_t get_cycles() {
ffffffe0002002a0:	fe010113          	addi	sp,sp,-32
ffffffe0002002a4:	00813c23          	sd	s0,24(sp)
ffffffe0002002a8:	02010413          	addi	s0,sp,32
    // 编写内联汇编，使用 rdtime 获取 time 寄存器中（也就是 mtime 寄存器）的值并返回
    uint64_t cycles;
    // printk("enter cycles\n");
    __asm__ volatile(
ffffffe0002002ac:	c01027f3          	rdtime	a5
ffffffe0002002b0:	fef43423          	sd	a5,-24(s0)
            "rdtime %[cycles]\n"
            : [cycles] "=r" (cycles)
            :
            : "memory"
            );
    return cycles;
ffffffe0002002b4:	fe843783          	ld	a5,-24(s0)
}
ffffffe0002002b8:	00078513          	mv	a0,a5
ffffffe0002002bc:	01813403          	ld	s0,24(sp)
ffffffe0002002c0:	02010113          	addi	sp,sp,32
ffffffe0002002c4:	00008067          	ret

ffffffe0002002c8 <clock_set_next_event>:

void clock_set_next_event() {
ffffffe0002002c8:	fe010113          	addi	sp,sp,-32
ffffffe0002002cc:	00113c23          	sd	ra,24(sp)
ffffffe0002002d0:	00813823          	sd	s0,16(sp)
ffffffe0002002d4:	02010413          	addi	s0,sp,32
    // 下一次时钟中断的时间点
    uint64_t next = get_cycles() + TIMECLOCK;
ffffffe0002002d8:	fc9ff0ef          	jal	ffffffe0002002a0 <get_cycles>
ffffffe0002002dc:	00050713          	mv	a4,a0
ffffffe0002002e0:	00005797          	auipc	a5,0x5
ffffffe0002002e4:	d2078793          	addi	a5,a5,-736 # ffffffe000205000 <TIMECLOCK>
ffffffe0002002e8:	0007b783          	ld	a5,0(a5)
ffffffe0002002ec:	00f707b3          	add	a5,a4,a5
ffffffe0002002f0:	fef43423          	sd	a5,-24(s0)

    // 使用 sbi_set_timer 来完成对下一次时钟中断的设置
    sbi_set_timer(next);
ffffffe0002002f4:	fe843503          	ld	a0,-24(s0)
ffffffe0002002f8:	604010ef          	jal	ffffffe0002018fc <sbi_set_timer>
ffffffe0002002fc:	00000013          	nop
ffffffe000200300:	01813083          	ld	ra,24(sp)
ffffffe000200304:	01013403          	ld	s0,16(sp)
ffffffe000200308:	02010113          	addi	sp,sp,32
ffffffe00020030c:	00008067          	ret

ffffffe000200310 <fixsize>:
#define MAX(a, b) ((a) > (b) ? (a) : (b))

void *free_page_start = &_ekernel;
struct buddy buddy;

static uint64_t fixsize(uint64_t size) {
ffffffe000200310:	fe010113          	addi	sp,sp,-32
ffffffe000200314:	00813c23          	sd	s0,24(sp)
ffffffe000200318:	02010413          	addi	s0,sp,32
ffffffe00020031c:	fea43423          	sd	a0,-24(s0)
    size --;
ffffffe000200320:	fe843783          	ld	a5,-24(s0)
ffffffe000200324:	fff78793          	addi	a5,a5,-1
ffffffe000200328:	fef43423          	sd	a5,-24(s0)
    size |= size >> 1;
ffffffe00020032c:	fe843783          	ld	a5,-24(s0)
ffffffe000200330:	0017d793          	srli	a5,a5,0x1
ffffffe000200334:	fe843703          	ld	a4,-24(s0)
ffffffe000200338:	00f767b3          	or	a5,a4,a5
ffffffe00020033c:	fef43423          	sd	a5,-24(s0)
    size |= size >> 2;
ffffffe000200340:	fe843783          	ld	a5,-24(s0)
ffffffe000200344:	0027d793          	srli	a5,a5,0x2
ffffffe000200348:	fe843703          	ld	a4,-24(s0)
ffffffe00020034c:	00f767b3          	or	a5,a4,a5
ffffffe000200350:	fef43423          	sd	a5,-24(s0)
    size |= size >> 4;
ffffffe000200354:	fe843783          	ld	a5,-24(s0)
ffffffe000200358:	0047d793          	srli	a5,a5,0x4
ffffffe00020035c:	fe843703          	ld	a4,-24(s0)
ffffffe000200360:	00f767b3          	or	a5,a4,a5
ffffffe000200364:	fef43423          	sd	a5,-24(s0)
    size |= size >> 8;
ffffffe000200368:	fe843783          	ld	a5,-24(s0)
ffffffe00020036c:	0087d793          	srli	a5,a5,0x8
ffffffe000200370:	fe843703          	ld	a4,-24(s0)
ffffffe000200374:	00f767b3          	or	a5,a4,a5
ffffffe000200378:	fef43423          	sd	a5,-24(s0)
    size |= size >> 16;
ffffffe00020037c:	fe843783          	ld	a5,-24(s0)
ffffffe000200380:	0107d793          	srli	a5,a5,0x10
ffffffe000200384:	fe843703          	ld	a4,-24(s0)
ffffffe000200388:	00f767b3          	or	a5,a4,a5
ffffffe00020038c:	fef43423          	sd	a5,-24(s0)
    size |= size >> 32;
ffffffe000200390:	fe843783          	ld	a5,-24(s0)
ffffffe000200394:	0207d793          	srli	a5,a5,0x20
ffffffe000200398:	fe843703          	ld	a4,-24(s0)
ffffffe00020039c:	00f767b3          	or	a5,a4,a5
ffffffe0002003a0:	fef43423          	sd	a5,-24(s0)
    return size + 1;
ffffffe0002003a4:	fe843783          	ld	a5,-24(s0)
ffffffe0002003a8:	00178793          	addi	a5,a5,1
}
ffffffe0002003ac:	00078513          	mv	a0,a5
ffffffe0002003b0:	01813403          	ld	s0,24(sp)
ffffffe0002003b4:	02010113          	addi	sp,sp,32
ffffffe0002003b8:	00008067          	ret

ffffffe0002003bc <buddy_init>:

void buddy_init() {
ffffffe0002003bc:	fd010113          	addi	sp,sp,-48
ffffffe0002003c0:	02113423          	sd	ra,40(sp)
ffffffe0002003c4:	02813023          	sd	s0,32(sp)
ffffffe0002003c8:	03010413          	addi	s0,sp,48
    uint64_t buddy_size = (uint64_t)PHY_SIZE / PGSIZE;
ffffffe0002003cc:	000087b7          	lui	a5,0x8
ffffffe0002003d0:	fef43423          	sd	a5,-24(s0)

    if (!IS_POWER_OF_2(buddy_size))
ffffffe0002003d4:	fe843783          	ld	a5,-24(s0)
ffffffe0002003d8:	fff78713          	addi	a4,a5,-1 # 7fff <PGSIZE+0x6fff>
ffffffe0002003dc:	fe843783          	ld	a5,-24(s0)
ffffffe0002003e0:	00f777b3          	and	a5,a4,a5
ffffffe0002003e4:	00078863          	beqz	a5,ffffffe0002003f4 <buddy_init+0x38>
        buddy_size = fixsize(buddy_size);
ffffffe0002003e8:	fe843503          	ld	a0,-24(s0)
ffffffe0002003ec:	f25ff0ef          	jal	ffffffe000200310 <fixsize>
ffffffe0002003f0:	fea43423          	sd	a0,-24(s0)

    buddy.size = buddy_size;
ffffffe0002003f4:	00009797          	auipc	a5,0x9
ffffffe0002003f8:	c2c78793          	addi	a5,a5,-980 # ffffffe000209020 <buddy>
ffffffe0002003fc:	fe843703          	ld	a4,-24(s0)
ffffffe000200400:	00e7b023          	sd	a4,0(a5)
    buddy.bitmap = free_page_start;
ffffffe000200404:	00005797          	auipc	a5,0x5
ffffffe000200408:	c0478793          	addi	a5,a5,-1020 # ffffffe000205008 <free_page_start>
ffffffe00020040c:	0007b703          	ld	a4,0(a5)
ffffffe000200410:	00009797          	auipc	a5,0x9
ffffffe000200414:	c1078793          	addi	a5,a5,-1008 # ffffffe000209020 <buddy>
ffffffe000200418:	00e7b423          	sd	a4,8(a5)
    free_page_start += 2 * buddy.size * sizeof(*buddy.bitmap);
ffffffe00020041c:	00005797          	auipc	a5,0x5
ffffffe000200420:	bec78793          	addi	a5,a5,-1044 # ffffffe000205008 <free_page_start>
ffffffe000200424:	0007b703          	ld	a4,0(a5)
ffffffe000200428:	00009797          	auipc	a5,0x9
ffffffe00020042c:	bf878793          	addi	a5,a5,-1032 # ffffffe000209020 <buddy>
ffffffe000200430:	0007b783          	ld	a5,0(a5)
ffffffe000200434:	00479793          	slli	a5,a5,0x4
ffffffe000200438:	00f70733          	add	a4,a4,a5
ffffffe00020043c:	00005797          	auipc	a5,0x5
ffffffe000200440:	bcc78793          	addi	a5,a5,-1076 # ffffffe000205008 <free_page_start>
ffffffe000200444:	00e7b023          	sd	a4,0(a5)
    memset(buddy.bitmap, 0, 2 * buddy.size * sizeof(*buddy.bitmap));
ffffffe000200448:	00009797          	auipc	a5,0x9
ffffffe00020044c:	bd878793          	addi	a5,a5,-1064 # ffffffe000209020 <buddy>
ffffffe000200450:	0087b703          	ld	a4,8(a5)
ffffffe000200454:	00009797          	auipc	a5,0x9
ffffffe000200458:	bcc78793          	addi	a5,a5,-1076 # ffffffe000209020 <buddy>
ffffffe00020045c:	0007b783          	ld	a5,0(a5)
ffffffe000200460:	00479793          	slli	a5,a5,0x4
ffffffe000200464:	00078613          	mv	a2,a5
ffffffe000200468:	00000593          	li	a1,0
ffffffe00020046c:	00070513          	mv	a0,a4
ffffffe000200470:	1cc030ef          	jal	ffffffe00020363c <memset>

    uint64_t node_size = buddy.size * 2;
ffffffe000200474:	00009797          	auipc	a5,0x9
ffffffe000200478:	bac78793          	addi	a5,a5,-1108 # ffffffe000209020 <buddy>
ffffffe00020047c:	0007b783          	ld	a5,0(a5)
ffffffe000200480:	00179793          	slli	a5,a5,0x1
ffffffe000200484:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < 2 * buddy.size - 1; ++i) {
ffffffe000200488:	fc043c23          	sd	zero,-40(s0)
ffffffe00020048c:	0500006f          	j	ffffffe0002004dc <buddy_init+0x120>
        if (IS_POWER_OF_2(i + 1))
ffffffe000200490:	fd843783          	ld	a5,-40(s0)
ffffffe000200494:	00178713          	addi	a4,a5,1
ffffffe000200498:	fd843783          	ld	a5,-40(s0)
ffffffe00020049c:	00f777b3          	and	a5,a4,a5
ffffffe0002004a0:	00079863          	bnez	a5,ffffffe0002004b0 <buddy_init+0xf4>
            node_size /= 2;
ffffffe0002004a4:	fe043783          	ld	a5,-32(s0)
ffffffe0002004a8:	0017d793          	srli	a5,a5,0x1
ffffffe0002004ac:	fef43023          	sd	a5,-32(s0)
        buddy.bitmap[i] = node_size;
ffffffe0002004b0:	00009797          	auipc	a5,0x9
ffffffe0002004b4:	b7078793          	addi	a5,a5,-1168 # ffffffe000209020 <buddy>
ffffffe0002004b8:	0087b703          	ld	a4,8(a5)
ffffffe0002004bc:	fd843783          	ld	a5,-40(s0)
ffffffe0002004c0:	00379793          	slli	a5,a5,0x3
ffffffe0002004c4:	00f707b3          	add	a5,a4,a5
ffffffe0002004c8:	fe043703          	ld	a4,-32(s0)
ffffffe0002004cc:	00e7b023          	sd	a4,0(a5)
    for (uint64_t i = 0; i < 2 * buddy.size - 1; ++i) {
ffffffe0002004d0:	fd843783          	ld	a5,-40(s0)
ffffffe0002004d4:	00178793          	addi	a5,a5,1
ffffffe0002004d8:	fcf43c23          	sd	a5,-40(s0)
ffffffe0002004dc:	00009797          	auipc	a5,0x9
ffffffe0002004e0:	b4478793          	addi	a5,a5,-1212 # ffffffe000209020 <buddy>
ffffffe0002004e4:	0007b783          	ld	a5,0(a5)
ffffffe0002004e8:	00179793          	slli	a5,a5,0x1
ffffffe0002004ec:	fff78793          	addi	a5,a5,-1
ffffffe0002004f0:	fd843703          	ld	a4,-40(s0)
ffffffe0002004f4:	f8f76ee3          	bltu	a4,a5,ffffffe000200490 <buddy_init+0xd4>
    }

    for (uint64_t pfn = 0; (uint64_t)PFN2PHYS(pfn) < VA2PA((uint64_t)free_page_start); ++pfn) {
ffffffe0002004f8:	fc043823          	sd	zero,-48(s0)
ffffffe0002004fc:	0180006f          	j	ffffffe000200514 <buddy_init+0x158>
        buddy_alloc(1);
ffffffe000200500:	00100513          	li	a0,1
ffffffe000200504:	1fc000ef          	jal	ffffffe000200700 <buddy_alloc>
    for (uint64_t pfn = 0; (uint64_t)PFN2PHYS(pfn) < VA2PA((uint64_t)free_page_start); ++pfn) {
ffffffe000200508:	fd043783          	ld	a5,-48(s0)
ffffffe00020050c:	00178793          	addi	a5,a5,1
ffffffe000200510:	fcf43823          	sd	a5,-48(s0)
ffffffe000200514:	fd043783          	ld	a5,-48(s0)
ffffffe000200518:	00c79713          	slli	a4,a5,0xc
ffffffe00020051c:	00100793          	li	a5,1
ffffffe000200520:	01f79793          	slli	a5,a5,0x1f
ffffffe000200524:	00f70733          	add	a4,a4,a5
ffffffe000200528:	00005797          	auipc	a5,0x5
ffffffe00020052c:	ae078793          	addi	a5,a5,-1312 # ffffffe000205008 <free_page_start>
ffffffe000200530:	0007b783          	ld	a5,0(a5)
ffffffe000200534:	00078693          	mv	a3,a5
ffffffe000200538:	04100793          	li	a5,65
ffffffe00020053c:	01f79793          	slli	a5,a5,0x1f
ffffffe000200540:	00f687b3          	add	a5,a3,a5
ffffffe000200544:	faf76ee3          	bltu	a4,a5,ffffffe000200500 <buddy_init+0x144>
    }

    printk("...buddy_init done!\n");
ffffffe000200548:	00004517          	auipc	a0,0x4
ffffffe00020054c:	ab850513          	addi	a0,a0,-1352 # ffffffe000204000 <_srodata>
ffffffe000200550:	7cd020ef          	jal	ffffffe00020351c <printk>
    return;
ffffffe000200554:	00000013          	nop
}
ffffffe000200558:	02813083          	ld	ra,40(sp)
ffffffe00020055c:	02013403          	ld	s0,32(sp)
ffffffe000200560:	03010113          	addi	sp,sp,48
ffffffe000200564:	00008067          	ret

ffffffe000200568 <buddy_free>:

void buddy_free(uint64_t pfn) {
ffffffe000200568:	fc010113          	addi	sp,sp,-64
ffffffe00020056c:	02813c23          	sd	s0,56(sp)
ffffffe000200570:	04010413          	addi	s0,sp,64
ffffffe000200574:	fca43423          	sd	a0,-56(s0)
    uint64_t node_size, index = 0;
ffffffe000200578:	fe043023          	sd	zero,-32(s0)
    uint64_t left_longest, right_longest;

    node_size = 1;
ffffffe00020057c:	00100793          	li	a5,1
ffffffe000200580:	fef43423          	sd	a5,-24(s0)
    index = pfn + buddy.size - 1;
ffffffe000200584:	00009797          	auipc	a5,0x9
ffffffe000200588:	a9c78793          	addi	a5,a5,-1380 # ffffffe000209020 <buddy>
ffffffe00020058c:	0007b703          	ld	a4,0(a5)
ffffffe000200590:	fc843783          	ld	a5,-56(s0)
ffffffe000200594:	00f707b3          	add	a5,a4,a5
ffffffe000200598:	fff78793          	addi	a5,a5,-1
ffffffe00020059c:	fef43023          	sd	a5,-32(s0)

    for (; buddy.bitmap[index]; index = PARENT(index)) {
ffffffe0002005a0:	02c0006f          	j	ffffffe0002005cc <buddy_free+0x64>
        node_size *= 2;
ffffffe0002005a4:	fe843783          	ld	a5,-24(s0)
ffffffe0002005a8:	00179793          	slli	a5,a5,0x1
ffffffe0002005ac:	fef43423          	sd	a5,-24(s0)
        if (index == 0)
ffffffe0002005b0:	fe043783          	ld	a5,-32(s0)
ffffffe0002005b4:	02078e63          	beqz	a5,ffffffe0002005f0 <buddy_free+0x88>
    for (; buddy.bitmap[index]; index = PARENT(index)) {
ffffffe0002005b8:	fe043783          	ld	a5,-32(s0)
ffffffe0002005bc:	00178793          	addi	a5,a5,1
ffffffe0002005c0:	0017d793          	srli	a5,a5,0x1
ffffffe0002005c4:	fff78793          	addi	a5,a5,-1
ffffffe0002005c8:	fef43023          	sd	a5,-32(s0)
ffffffe0002005cc:	00009797          	auipc	a5,0x9
ffffffe0002005d0:	a5478793          	addi	a5,a5,-1452 # ffffffe000209020 <buddy>
ffffffe0002005d4:	0087b703          	ld	a4,8(a5)
ffffffe0002005d8:	fe043783          	ld	a5,-32(s0)
ffffffe0002005dc:	00379793          	slli	a5,a5,0x3
ffffffe0002005e0:	00f707b3          	add	a5,a4,a5
ffffffe0002005e4:	0007b783          	ld	a5,0(a5)
ffffffe0002005e8:	fa079ee3          	bnez	a5,ffffffe0002005a4 <buddy_free+0x3c>
ffffffe0002005ec:	0080006f          	j	ffffffe0002005f4 <buddy_free+0x8c>
            break;
ffffffe0002005f0:	00000013          	nop
    }

    buddy.bitmap[index] = node_size;
ffffffe0002005f4:	00009797          	auipc	a5,0x9
ffffffe0002005f8:	a2c78793          	addi	a5,a5,-1492 # ffffffe000209020 <buddy>
ffffffe0002005fc:	0087b703          	ld	a4,8(a5)
ffffffe000200600:	fe043783          	ld	a5,-32(s0)
ffffffe000200604:	00379793          	slli	a5,a5,0x3
ffffffe000200608:	00f707b3          	add	a5,a4,a5
ffffffe00020060c:	fe843703          	ld	a4,-24(s0)
ffffffe000200610:	00e7b023          	sd	a4,0(a5)

    while (index) {
ffffffe000200614:	0d00006f          	j	ffffffe0002006e4 <buddy_free+0x17c>
        index = PARENT(index);
ffffffe000200618:	fe043783          	ld	a5,-32(s0)
ffffffe00020061c:	00178793          	addi	a5,a5,1
ffffffe000200620:	0017d793          	srli	a5,a5,0x1
ffffffe000200624:	fff78793          	addi	a5,a5,-1
ffffffe000200628:	fef43023          	sd	a5,-32(s0)
        node_size *= 2;
ffffffe00020062c:	fe843783          	ld	a5,-24(s0)
ffffffe000200630:	00179793          	slli	a5,a5,0x1
ffffffe000200634:	fef43423          	sd	a5,-24(s0)

        left_longest = buddy.bitmap[LEFT_LEAF(index)];
ffffffe000200638:	00009797          	auipc	a5,0x9
ffffffe00020063c:	9e878793          	addi	a5,a5,-1560 # ffffffe000209020 <buddy>
ffffffe000200640:	0087b703          	ld	a4,8(a5)
ffffffe000200644:	fe043783          	ld	a5,-32(s0)
ffffffe000200648:	00479793          	slli	a5,a5,0x4
ffffffe00020064c:	00878793          	addi	a5,a5,8
ffffffe000200650:	00f707b3          	add	a5,a4,a5
ffffffe000200654:	0007b783          	ld	a5,0(a5)
ffffffe000200658:	fcf43c23          	sd	a5,-40(s0)
        right_longest = buddy.bitmap[RIGHT_LEAF(index)];
ffffffe00020065c:	00009797          	auipc	a5,0x9
ffffffe000200660:	9c478793          	addi	a5,a5,-1596 # ffffffe000209020 <buddy>
ffffffe000200664:	0087b703          	ld	a4,8(a5)
ffffffe000200668:	fe043783          	ld	a5,-32(s0)
ffffffe00020066c:	00178793          	addi	a5,a5,1
ffffffe000200670:	00479793          	slli	a5,a5,0x4
ffffffe000200674:	00f707b3          	add	a5,a4,a5
ffffffe000200678:	0007b783          	ld	a5,0(a5)
ffffffe00020067c:	fcf43823          	sd	a5,-48(s0)

        if (left_longest + right_longest == node_size) 
ffffffe000200680:	fd843703          	ld	a4,-40(s0)
ffffffe000200684:	fd043783          	ld	a5,-48(s0)
ffffffe000200688:	00f707b3          	add	a5,a4,a5
ffffffe00020068c:	fe843703          	ld	a4,-24(s0)
ffffffe000200690:	02f71463          	bne	a4,a5,ffffffe0002006b8 <buddy_free+0x150>
            buddy.bitmap[index] = node_size;
ffffffe000200694:	00009797          	auipc	a5,0x9
ffffffe000200698:	98c78793          	addi	a5,a5,-1652 # ffffffe000209020 <buddy>
ffffffe00020069c:	0087b703          	ld	a4,8(a5)
ffffffe0002006a0:	fe043783          	ld	a5,-32(s0)
ffffffe0002006a4:	00379793          	slli	a5,a5,0x3
ffffffe0002006a8:	00f707b3          	add	a5,a4,a5
ffffffe0002006ac:	fe843703          	ld	a4,-24(s0)
ffffffe0002006b0:	00e7b023          	sd	a4,0(a5)
ffffffe0002006b4:	0300006f          	j	ffffffe0002006e4 <buddy_free+0x17c>
        else
            buddy.bitmap[index] = MAX(left_longest, right_longest);
ffffffe0002006b8:	00009797          	auipc	a5,0x9
ffffffe0002006bc:	96878793          	addi	a5,a5,-1688 # ffffffe000209020 <buddy>
ffffffe0002006c0:	0087b703          	ld	a4,8(a5)
ffffffe0002006c4:	fe043783          	ld	a5,-32(s0)
ffffffe0002006c8:	00379793          	slli	a5,a5,0x3
ffffffe0002006cc:	00f706b3          	add	a3,a4,a5
ffffffe0002006d0:	fd843703          	ld	a4,-40(s0)
ffffffe0002006d4:	fd043783          	ld	a5,-48(s0)
ffffffe0002006d8:	00e7f463          	bgeu	a5,a4,ffffffe0002006e0 <buddy_free+0x178>
ffffffe0002006dc:	00070793          	mv	a5,a4
ffffffe0002006e0:	00f6b023          	sd	a5,0(a3)
    while (index) {
ffffffe0002006e4:	fe043783          	ld	a5,-32(s0)
ffffffe0002006e8:	f20798e3          	bnez	a5,ffffffe000200618 <buddy_free+0xb0>
    }
}
ffffffe0002006ec:	00000013          	nop
ffffffe0002006f0:	00000013          	nop
ffffffe0002006f4:	03813403          	ld	s0,56(sp)
ffffffe0002006f8:	04010113          	addi	sp,sp,64
ffffffe0002006fc:	00008067          	ret

ffffffe000200700 <buddy_alloc>:

uint64_t buddy_alloc(uint64_t nrpages) {
ffffffe000200700:	fc010113          	addi	sp,sp,-64
ffffffe000200704:	02113c23          	sd	ra,56(sp)
ffffffe000200708:	02813823          	sd	s0,48(sp)
ffffffe00020070c:	04010413          	addi	s0,sp,64
ffffffe000200710:	fca43423          	sd	a0,-56(s0)
    uint64_t index = 0;
ffffffe000200714:	fe043423          	sd	zero,-24(s0)
    uint64_t node_size;
    uint64_t pfn = 0;
ffffffe000200718:	fc043c23          	sd	zero,-40(s0)

    if (nrpages <= 0)
ffffffe00020071c:	fc843783          	ld	a5,-56(s0)
ffffffe000200720:	00079863          	bnez	a5,ffffffe000200730 <buddy_alloc+0x30>
        nrpages = 1;
ffffffe000200724:	00100793          	li	a5,1
ffffffe000200728:	fcf43423          	sd	a5,-56(s0)
ffffffe00020072c:	0240006f          	j	ffffffe000200750 <buddy_alloc+0x50>
    else if (!IS_POWER_OF_2(nrpages))
ffffffe000200730:	fc843783          	ld	a5,-56(s0)
ffffffe000200734:	fff78713          	addi	a4,a5,-1
ffffffe000200738:	fc843783          	ld	a5,-56(s0)
ffffffe00020073c:	00f777b3          	and	a5,a4,a5
ffffffe000200740:	00078863          	beqz	a5,ffffffe000200750 <buddy_alloc+0x50>
        nrpages = fixsize(nrpages);
ffffffe000200744:	fc843503          	ld	a0,-56(s0)
ffffffe000200748:	bc9ff0ef          	jal	ffffffe000200310 <fixsize>
ffffffe00020074c:	fca43423          	sd	a0,-56(s0)

    if (buddy.bitmap[index] < nrpages)
ffffffe000200750:	00009797          	auipc	a5,0x9
ffffffe000200754:	8d078793          	addi	a5,a5,-1840 # ffffffe000209020 <buddy>
ffffffe000200758:	0087b703          	ld	a4,8(a5)
ffffffe00020075c:	fe843783          	ld	a5,-24(s0)
ffffffe000200760:	00379793          	slli	a5,a5,0x3
ffffffe000200764:	00f707b3          	add	a5,a4,a5
ffffffe000200768:	0007b783          	ld	a5,0(a5)
ffffffe00020076c:	fc843703          	ld	a4,-56(s0)
ffffffe000200770:	00e7f663          	bgeu	a5,a4,ffffffe00020077c <buddy_alloc+0x7c>
        return 0;
ffffffe000200774:	00000793          	li	a5,0
ffffffe000200778:	1480006f          	j	ffffffe0002008c0 <buddy_alloc+0x1c0>

    for(node_size = buddy.size; node_size != nrpages; node_size /= 2 ) {
ffffffe00020077c:	00009797          	auipc	a5,0x9
ffffffe000200780:	8a478793          	addi	a5,a5,-1884 # ffffffe000209020 <buddy>
ffffffe000200784:	0007b783          	ld	a5,0(a5)
ffffffe000200788:	fef43023          	sd	a5,-32(s0)
ffffffe00020078c:	05c0006f          	j	ffffffe0002007e8 <buddy_alloc+0xe8>
        if (buddy.bitmap[LEFT_LEAF(index)] >= nrpages)
ffffffe000200790:	00009797          	auipc	a5,0x9
ffffffe000200794:	89078793          	addi	a5,a5,-1904 # ffffffe000209020 <buddy>
ffffffe000200798:	0087b703          	ld	a4,8(a5)
ffffffe00020079c:	fe843783          	ld	a5,-24(s0)
ffffffe0002007a0:	00479793          	slli	a5,a5,0x4
ffffffe0002007a4:	00878793          	addi	a5,a5,8
ffffffe0002007a8:	00f707b3          	add	a5,a4,a5
ffffffe0002007ac:	0007b783          	ld	a5,0(a5)
ffffffe0002007b0:	fc843703          	ld	a4,-56(s0)
ffffffe0002007b4:	00e7ec63          	bltu	a5,a4,ffffffe0002007cc <buddy_alloc+0xcc>
            index = LEFT_LEAF(index);
ffffffe0002007b8:	fe843783          	ld	a5,-24(s0)
ffffffe0002007bc:	00179793          	slli	a5,a5,0x1
ffffffe0002007c0:	00178793          	addi	a5,a5,1
ffffffe0002007c4:	fef43423          	sd	a5,-24(s0)
ffffffe0002007c8:	0140006f          	j	ffffffe0002007dc <buddy_alloc+0xdc>
        else
            index = RIGHT_LEAF(index);
ffffffe0002007cc:	fe843783          	ld	a5,-24(s0)
ffffffe0002007d0:	00178793          	addi	a5,a5,1
ffffffe0002007d4:	00179793          	slli	a5,a5,0x1
ffffffe0002007d8:	fef43423          	sd	a5,-24(s0)
    for(node_size = buddy.size; node_size != nrpages; node_size /= 2 ) {
ffffffe0002007dc:	fe043783          	ld	a5,-32(s0)
ffffffe0002007e0:	0017d793          	srli	a5,a5,0x1
ffffffe0002007e4:	fef43023          	sd	a5,-32(s0)
ffffffe0002007e8:	fe043703          	ld	a4,-32(s0)
ffffffe0002007ec:	fc843783          	ld	a5,-56(s0)
ffffffe0002007f0:	faf710e3          	bne	a4,a5,ffffffe000200790 <buddy_alloc+0x90>
    }

    buddy.bitmap[index] = 0;
ffffffe0002007f4:	00009797          	auipc	a5,0x9
ffffffe0002007f8:	82c78793          	addi	a5,a5,-2004 # ffffffe000209020 <buddy>
ffffffe0002007fc:	0087b703          	ld	a4,8(a5)
ffffffe000200800:	fe843783          	ld	a5,-24(s0)
ffffffe000200804:	00379793          	slli	a5,a5,0x3
ffffffe000200808:	00f707b3          	add	a5,a4,a5
ffffffe00020080c:	0007b023          	sd	zero,0(a5)
    pfn = (index + 1) * node_size - buddy.size;
ffffffe000200810:	fe843783          	ld	a5,-24(s0)
ffffffe000200814:	00178713          	addi	a4,a5,1
ffffffe000200818:	fe043783          	ld	a5,-32(s0)
ffffffe00020081c:	02f70733          	mul	a4,a4,a5
ffffffe000200820:	00009797          	auipc	a5,0x9
ffffffe000200824:	80078793          	addi	a5,a5,-2048 # ffffffe000209020 <buddy>
ffffffe000200828:	0007b783          	ld	a5,0(a5)
ffffffe00020082c:	40f707b3          	sub	a5,a4,a5
ffffffe000200830:	fcf43c23          	sd	a5,-40(s0)

    while (index) {
ffffffe000200834:	0800006f          	j	ffffffe0002008b4 <buddy_alloc+0x1b4>
        index = PARENT(index);
ffffffe000200838:	fe843783          	ld	a5,-24(s0)
ffffffe00020083c:	00178793          	addi	a5,a5,1
ffffffe000200840:	0017d793          	srli	a5,a5,0x1
ffffffe000200844:	fff78793          	addi	a5,a5,-1
ffffffe000200848:	fef43423          	sd	a5,-24(s0)
        buddy.bitmap[index] = 
            MAX(buddy.bitmap[LEFT_LEAF(index)], buddy.bitmap[RIGHT_LEAF(index)]);
ffffffe00020084c:	00008797          	auipc	a5,0x8
ffffffe000200850:	7d478793          	addi	a5,a5,2004 # ffffffe000209020 <buddy>
ffffffe000200854:	0087b703          	ld	a4,8(a5)
ffffffe000200858:	fe843783          	ld	a5,-24(s0)
ffffffe00020085c:	00178793          	addi	a5,a5,1
ffffffe000200860:	00479793          	slli	a5,a5,0x4
ffffffe000200864:	00f707b3          	add	a5,a4,a5
ffffffe000200868:	0007b603          	ld	a2,0(a5)
ffffffe00020086c:	00008797          	auipc	a5,0x8
ffffffe000200870:	7b478793          	addi	a5,a5,1972 # ffffffe000209020 <buddy>
ffffffe000200874:	0087b703          	ld	a4,8(a5)
ffffffe000200878:	fe843783          	ld	a5,-24(s0)
ffffffe00020087c:	00479793          	slli	a5,a5,0x4
ffffffe000200880:	00878793          	addi	a5,a5,8
ffffffe000200884:	00f707b3          	add	a5,a4,a5
ffffffe000200888:	0007b703          	ld	a4,0(a5)
        buddy.bitmap[index] = 
ffffffe00020088c:	00008797          	auipc	a5,0x8
ffffffe000200890:	79478793          	addi	a5,a5,1940 # ffffffe000209020 <buddy>
ffffffe000200894:	0087b683          	ld	a3,8(a5)
ffffffe000200898:	fe843783          	ld	a5,-24(s0)
ffffffe00020089c:	00379793          	slli	a5,a5,0x3
ffffffe0002008a0:	00f686b3          	add	a3,a3,a5
            MAX(buddy.bitmap[LEFT_LEAF(index)], buddy.bitmap[RIGHT_LEAF(index)]);
ffffffe0002008a4:	00060793          	mv	a5,a2
ffffffe0002008a8:	00e7f463          	bgeu	a5,a4,ffffffe0002008b0 <buddy_alloc+0x1b0>
ffffffe0002008ac:	00070793          	mv	a5,a4
        buddy.bitmap[index] = 
ffffffe0002008b0:	00f6b023          	sd	a5,0(a3)
    while (index) {
ffffffe0002008b4:	fe843783          	ld	a5,-24(s0)
ffffffe0002008b8:	f80790e3          	bnez	a5,ffffffe000200838 <buddy_alloc+0x138>
    }
    
    return pfn;
ffffffe0002008bc:	fd843783          	ld	a5,-40(s0)
}
ffffffe0002008c0:	00078513          	mv	a0,a5
ffffffe0002008c4:	03813083          	ld	ra,56(sp)
ffffffe0002008c8:	03013403          	ld	s0,48(sp)
ffffffe0002008cc:	04010113          	addi	sp,sp,64
ffffffe0002008d0:	00008067          	ret

ffffffe0002008d4 <alloc_pages>:


void *alloc_pages(uint64_t nrpages) {
ffffffe0002008d4:	fd010113          	addi	sp,sp,-48
ffffffe0002008d8:	02113423          	sd	ra,40(sp)
ffffffe0002008dc:	02813023          	sd	s0,32(sp)
ffffffe0002008e0:	03010413          	addi	s0,sp,48
ffffffe0002008e4:	fca43c23          	sd	a0,-40(s0)
    uint64_t pfn = buddy_alloc(nrpages);
ffffffe0002008e8:	fd843503          	ld	a0,-40(s0)
ffffffe0002008ec:	e15ff0ef          	jal	ffffffe000200700 <buddy_alloc>
ffffffe0002008f0:	fea43423          	sd	a0,-24(s0)
    if (pfn == 0)
ffffffe0002008f4:	fe843783          	ld	a5,-24(s0)
ffffffe0002008f8:	00079663          	bnez	a5,ffffffe000200904 <alloc_pages+0x30>
        return 0;
ffffffe0002008fc:	00000793          	li	a5,0
ffffffe000200900:	0180006f          	j	ffffffe000200918 <alloc_pages+0x44>
    return (void *)(PA2VA(PFN2PHYS(pfn)));
ffffffe000200904:	fe843783          	ld	a5,-24(s0)
ffffffe000200908:	00c79713          	slli	a4,a5,0xc
ffffffe00020090c:	fff00793          	li	a5,-1
ffffffe000200910:	02579793          	slli	a5,a5,0x25
ffffffe000200914:	00f707b3          	add	a5,a4,a5
}
ffffffe000200918:	00078513          	mv	a0,a5
ffffffe00020091c:	02813083          	ld	ra,40(sp)
ffffffe000200920:	02013403          	ld	s0,32(sp)
ffffffe000200924:	03010113          	addi	sp,sp,48
ffffffe000200928:	00008067          	ret

ffffffe00020092c <alloc_page>:

void *alloc_page() {
ffffffe00020092c:	ff010113          	addi	sp,sp,-16
ffffffe000200930:	00113423          	sd	ra,8(sp)
ffffffe000200934:	00813023          	sd	s0,0(sp)
ffffffe000200938:	01010413          	addi	s0,sp,16
    return alloc_pages(1);
ffffffe00020093c:	00100513          	li	a0,1
ffffffe000200940:	f95ff0ef          	jal	ffffffe0002008d4 <alloc_pages>
ffffffe000200944:	00050793          	mv	a5,a0
}
ffffffe000200948:	00078513          	mv	a0,a5
ffffffe00020094c:	00813083          	ld	ra,8(sp)
ffffffe000200950:	00013403          	ld	s0,0(sp)
ffffffe000200954:	01010113          	addi	sp,sp,16
ffffffe000200958:	00008067          	ret

ffffffe00020095c <free_pages>:

void free_pages(void *va) {
ffffffe00020095c:	fe010113          	addi	sp,sp,-32
ffffffe000200960:	00113c23          	sd	ra,24(sp)
ffffffe000200964:	00813823          	sd	s0,16(sp)
ffffffe000200968:	02010413          	addi	s0,sp,32
ffffffe00020096c:	fea43423          	sd	a0,-24(s0)
    buddy_free(PHYS2PFN(VA2PA((uint64_t)va)));
ffffffe000200970:	fe843703          	ld	a4,-24(s0)
ffffffe000200974:	00100793          	li	a5,1
ffffffe000200978:	02579793          	slli	a5,a5,0x25
ffffffe00020097c:	00f707b3          	add	a5,a4,a5
ffffffe000200980:	00c7d793          	srli	a5,a5,0xc
ffffffe000200984:	00078513          	mv	a0,a5
ffffffe000200988:	be1ff0ef          	jal	ffffffe000200568 <buddy_free>
}
ffffffe00020098c:	00000013          	nop
ffffffe000200990:	01813083          	ld	ra,24(sp)
ffffffe000200994:	01013403          	ld	s0,16(sp)
ffffffe000200998:	02010113          	addi	sp,sp,32
ffffffe00020099c:	00008067          	ret

ffffffe0002009a0 <kalloc>:

void *kalloc() {
ffffffe0002009a0:	ff010113          	addi	sp,sp,-16
ffffffe0002009a4:	00113423          	sd	ra,8(sp)
ffffffe0002009a8:	00813023          	sd	s0,0(sp)
ffffffe0002009ac:	01010413          	addi	s0,sp,16
    // r = kmem.freelist;
    // kmem.freelist = r->next;
    
    // memset((void *)r, 0x0, PGSIZE);
    // return (void *)r;
    return alloc_page();
ffffffe0002009b0:	f7dff0ef          	jal	ffffffe00020092c <alloc_page>
ffffffe0002009b4:	00050793          	mv	a5,a0
}
ffffffe0002009b8:	00078513          	mv	a0,a5
ffffffe0002009bc:	00813083          	ld	ra,8(sp)
ffffffe0002009c0:	00013403          	ld	s0,0(sp)
ffffffe0002009c4:	01010113          	addi	sp,sp,16
ffffffe0002009c8:	00008067          	ret

ffffffe0002009cc <kfree>:

void kfree(void *addr) {
ffffffe0002009cc:	fe010113          	addi	sp,sp,-32
ffffffe0002009d0:	00113c23          	sd	ra,24(sp)
ffffffe0002009d4:	00813823          	sd	s0,16(sp)
ffffffe0002009d8:	02010413          	addi	s0,sp,32
ffffffe0002009dc:	fea43423          	sd	a0,-24(s0)
    // memset(addr, 0x0, (uint64_t)PGSIZE);

    // r = (struct run *)addr;
    // r->next = kmem.freelist;
    // kmem.freelist = r;
    free_pages(addr);
ffffffe0002009e0:	fe843503          	ld	a0,-24(s0)
ffffffe0002009e4:	f79ff0ef          	jal	ffffffe00020095c <free_pages>

    return;
ffffffe0002009e8:	00000013          	nop
}
ffffffe0002009ec:	01813083          	ld	ra,24(sp)
ffffffe0002009f0:	01013403          	ld	s0,16(sp)
ffffffe0002009f4:	02010113          	addi	sp,sp,32
ffffffe0002009f8:	00008067          	ret

ffffffe0002009fc <kfreerange>:

void kfreerange(char *start, char *end) {
ffffffe0002009fc:	fd010113          	addi	sp,sp,-48
ffffffe000200a00:	02113423          	sd	ra,40(sp)
ffffffe000200a04:	02813023          	sd	s0,32(sp)
ffffffe000200a08:	03010413          	addi	s0,sp,48
ffffffe000200a0c:	fca43c23          	sd	a0,-40(s0)
ffffffe000200a10:	fcb43823          	sd	a1,-48(s0)
    char *addr = (char *)PGROUNDUP((uintptr_t)start);
ffffffe000200a14:	fd843703          	ld	a4,-40(s0)
ffffffe000200a18:	000017b7          	lui	a5,0x1
ffffffe000200a1c:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000200a20:	00f70733          	add	a4,a4,a5
ffffffe000200a24:	fffff7b7          	lui	a5,0xfffff
ffffffe000200a28:	00f777b3          	and	a5,a4,a5
ffffffe000200a2c:	fef43423          	sd	a5,-24(s0)
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
ffffffe000200a30:	01c0006f          	j	ffffffe000200a4c <kfreerange+0x50>
        kfree((void *)addr);
ffffffe000200a34:	fe843503          	ld	a0,-24(s0)
ffffffe000200a38:	f95ff0ef          	jal	ffffffe0002009cc <kfree>
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
ffffffe000200a3c:	fe843703          	ld	a4,-24(s0)
ffffffe000200a40:	000017b7          	lui	a5,0x1
ffffffe000200a44:	00f707b3          	add	a5,a4,a5
ffffffe000200a48:	fef43423          	sd	a5,-24(s0)
ffffffe000200a4c:	fe843703          	ld	a4,-24(s0)
ffffffe000200a50:	000017b7          	lui	a5,0x1
ffffffe000200a54:	00f70733          	add	a4,a4,a5
ffffffe000200a58:	fd043783          	ld	a5,-48(s0)
ffffffe000200a5c:	fce7fce3          	bgeu	a5,a4,ffffffe000200a34 <kfreerange+0x38>
    }
}
ffffffe000200a60:	00000013          	nop
ffffffe000200a64:	00000013          	nop
ffffffe000200a68:	02813083          	ld	ra,40(sp)
ffffffe000200a6c:	02013403          	ld	s0,32(sp)
ffffffe000200a70:	03010113          	addi	sp,sp,48
ffffffe000200a74:	00008067          	ret

ffffffe000200a78 <mm_init>:

void mm_init(void) {
ffffffe000200a78:	ff010113          	addi	sp,sp,-16
ffffffe000200a7c:	00113423          	sd	ra,8(sp)
ffffffe000200a80:	00813023          	sd	s0,0(sp)
ffffffe000200a84:	01010413          	addi	s0,sp,16
    // kfreerange(_ekernel, (char *)PHY_END+PA2VA_OFFSET);
    buddy_init();
ffffffe000200a88:	935ff0ef          	jal	ffffffe0002003bc <buddy_init>
    printk("...mm_init done!\n");
ffffffe000200a8c:	00003517          	auipc	a0,0x3
ffffffe000200a90:	58c50513          	addi	a0,a0,1420 # ffffffe000204018 <_srodata+0x18>
ffffffe000200a94:	289020ef          	jal	ffffffe00020351c <printk>
}
ffffffe000200a98:	00000013          	nop
ffffffe000200a9c:	00813083          	ld	ra,8(sp)
ffffffe000200aa0:	00013403          	ld	s0,0(sp)
ffffffe000200aa4:	01010113          	addi	sp,sp,16
ffffffe000200aa8:	00008067          	ret

ffffffe000200aac <task_init>:

struct task_struct *idle;           // idle process
struct task_struct *current;        // 指向当前运行线程的 task_struct
struct task_struct *task[NR_TASKS]; // 线程数组，所有的线程都保存在此

void task_init() {
ffffffe000200aac:	f9010113          	addi	sp,sp,-112
ffffffe000200ab0:	06113423          	sd	ra,104(sp)
ffffffe000200ab4:	06813023          	sd	s0,96(sp)
ffffffe000200ab8:	04913c23          	sd	s1,88(sp)
ffffffe000200abc:	07010413          	addi	s0,sp,112
    // 2. 设置 state 为 TASK_RUNNING;
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // idle->thread.ra = (uint64_t)__dummy;
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle
    srand(2024);
ffffffe000200ac0:	7e800513          	li	a0,2024
ffffffe000200ac4:	2d9020ef          	jal	ffffffe00020359c <srand>
    idle = (struct task_struct* )kalloc(); // 类型转换
ffffffe000200ac8:	ed9ff0ef          	jal	ffffffe0002009a0 <kalloc>
ffffffe000200acc:	00050713          	mv	a4,a0
ffffffe000200ad0:	00008797          	auipc	a5,0x8
ffffffe000200ad4:	53878793          	addi	a5,a5,1336 # ffffffe000209008 <idle>
ffffffe000200ad8:	00e7b023          	sd	a4,0(a5)
    if (idle == NULL) {
ffffffe000200adc:	00008797          	auipc	a5,0x8
ffffffe000200ae0:	52c78793          	addi	a5,a5,1324 # ffffffe000209008 <idle>
ffffffe000200ae4:	0007b783          	ld	a5,0(a5)
ffffffe000200ae8:	00079a63          	bnez	a5,ffffffe000200afc <task_init+0x50>
        printk("kalloc失败\n");
ffffffe000200aec:	00003517          	auipc	a0,0x3
ffffffe000200af0:	54450513          	addi	a0,a0,1348 # ffffffe000204030 <_srodata+0x30>
ffffffe000200af4:	229020ef          	jal	ffffffe00020351c <printk>
ffffffe000200af8:	0480006f          	j	ffffffe000200b40 <task_init+0x94>
    } else {
        idle->state = TASK_RUNNING;
ffffffe000200afc:	00008797          	auipc	a5,0x8
ffffffe000200b00:	50c78793          	addi	a5,a5,1292 # ffffffe000209008 <idle>
ffffffe000200b04:	0007b783          	ld	a5,0(a5)
ffffffe000200b08:	0007b023          	sd	zero,0(a5)
        idle->counter = 0;
ffffffe000200b0c:	00008797          	auipc	a5,0x8
ffffffe000200b10:	4fc78793          	addi	a5,a5,1276 # ffffffe000209008 <idle>
ffffffe000200b14:	0007b783          	ld	a5,0(a5)
ffffffe000200b18:	0007b423          	sd	zero,8(a5)
        idle->priority = 1;
ffffffe000200b1c:	00008797          	auipc	a5,0x8
ffffffe000200b20:	4ec78793          	addi	a5,a5,1260 # ffffffe000209008 <idle>
ffffffe000200b24:	0007b783          	ld	a5,0(a5)
ffffffe000200b28:	00100713          	li	a4,1
ffffffe000200b2c:	00e7b823          	sd	a4,16(a5)
        idle->pid = 0;
ffffffe000200b30:	00008797          	auipc	a5,0x8
ffffffe000200b34:	4d878793          	addi	a5,a5,1240 # ffffffe000209008 <idle>
ffffffe000200b38:	0007b783          	ld	a5,0(a5)
ffffffe000200b3c:	0007bc23          	sd	zero,24(a5)
    }
    current = idle;
ffffffe000200b40:	00008797          	auipc	a5,0x8
ffffffe000200b44:	4c878793          	addi	a5,a5,1224 # ffffffe000209008 <idle>
ffffffe000200b48:	0007b703          	ld	a4,0(a5)
ffffffe000200b4c:	00008797          	auipc	a5,0x8
ffffffe000200b50:	4c478793          	addi	a5,a5,1220 # ffffffe000209010 <current>
ffffffe000200b54:	00e7b023          	sd	a4,0(a5)
    task[0] = idle;
ffffffe000200b58:	00008797          	auipc	a5,0x8
ffffffe000200b5c:	4b078793          	addi	a5,a5,1200 # ffffffe000209008 <idle>
ffffffe000200b60:	0007b703          	ld	a4,0(a5)
ffffffe000200b64:	00008797          	auipc	a5,0x8
ffffffe000200b68:	4cc78793          	addi	a5,a5,1228 # ffffffe000209030 <task>
ffffffe000200b6c:	00e7b023          	sd	a4,0(a5)
    //task[i].counter  = 0;
    //task[i].priority = rand() 产生的随机数（控制范围在 [PRIORITY_MIN, PRIORITY_MAX] 之间）
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.3.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址
    for (int i = 1; i < NR_TASKS; i++){
ffffffe000200b70:	00100793          	li	a5,1
ffffffe000200b74:	fcf42e23          	sw	a5,-36(s0)
ffffffe000200b78:	4440006f          	j	ffffffe000200fbc <task_init+0x510>
        task[i] = (struct task_struct* )kalloc();
ffffffe000200b7c:	e25ff0ef          	jal	ffffffe0002009a0 <kalloc>
ffffffe000200b80:	00050693          	mv	a3,a0
ffffffe000200b84:	00008717          	auipc	a4,0x8
ffffffe000200b88:	4ac70713          	addi	a4,a4,1196 # ffffffe000209030 <task>
ffffffe000200b8c:	fdc42783          	lw	a5,-36(s0)
ffffffe000200b90:	00379793          	slli	a5,a5,0x3
ffffffe000200b94:	00f707b3          	add	a5,a4,a5
ffffffe000200b98:	00d7b023          	sd	a3,0(a5)
        task[i]->state = TASK_RUNNING;
ffffffe000200b9c:	00008717          	auipc	a4,0x8
ffffffe000200ba0:	49470713          	addi	a4,a4,1172 # ffffffe000209030 <task>
ffffffe000200ba4:	fdc42783          	lw	a5,-36(s0)
ffffffe000200ba8:	00379793          	slli	a5,a5,0x3
ffffffe000200bac:	00f707b3          	add	a5,a4,a5
ffffffe000200bb0:	0007b783          	ld	a5,0(a5)
ffffffe000200bb4:	0007b023          	sd	zero,0(a5)
        task[i]->counter = 0;
ffffffe000200bb8:	00008717          	auipc	a4,0x8
ffffffe000200bbc:	47870713          	addi	a4,a4,1144 # ffffffe000209030 <task>
ffffffe000200bc0:	fdc42783          	lw	a5,-36(s0)
ffffffe000200bc4:	00379793          	slli	a5,a5,0x3
ffffffe000200bc8:	00f707b3          	add	a5,a4,a5
ffffffe000200bcc:	0007b783          	ld	a5,0(a5)
ffffffe000200bd0:	0007b423          	sd	zero,8(a5)
        task[i]->priority = rand() % (PRIORITY_MAX - PRIORITY_MIN + 1) + PRIORITY_MIN;
ffffffe000200bd4:	20d020ef          	jal	ffffffe0002035e0 <rand>
ffffffe000200bd8:	00050793          	mv	a5,a0
ffffffe000200bdc:	00078713          	mv	a4,a5
ffffffe000200be0:	00a00793          	li	a5,10
ffffffe000200be4:	02f767bb          	remw	a5,a4,a5
ffffffe000200be8:	0007879b          	sext.w	a5,a5
ffffffe000200bec:	0017879b          	addiw	a5,a5,1
ffffffe000200bf0:	0007869b          	sext.w	a3,a5
ffffffe000200bf4:	00008717          	auipc	a4,0x8
ffffffe000200bf8:	43c70713          	addi	a4,a4,1084 # ffffffe000209030 <task>
ffffffe000200bfc:	fdc42783          	lw	a5,-36(s0)
ffffffe000200c00:	00379793          	slli	a5,a5,0x3
ffffffe000200c04:	00f707b3          	add	a5,a4,a5
ffffffe000200c08:	0007b783          	ld	a5,0(a5)
ffffffe000200c0c:	00068713          	mv	a4,a3
ffffffe000200c10:	00e7b823          	sd	a4,16(a5)
        task[i]->pid = i;
ffffffe000200c14:	00008717          	auipc	a4,0x8
ffffffe000200c18:	41c70713          	addi	a4,a4,1052 # ffffffe000209030 <task>
ffffffe000200c1c:	fdc42783          	lw	a5,-36(s0)
ffffffe000200c20:	00379793          	slli	a5,a5,0x3
ffffffe000200c24:	00f707b3          	add	a5,a4,a5
ffffffe000200c28:	0007b783          	ld	a5,0(a5)
ffffffe000200c2c:	fdc42703          	lw	a4,-36(s0)
ffffffe000200c30:	00e7bc23          	sd	a4,24(a5)
        task[i]->thread.ra = (uint64_t)(&__dummy);
ffffffe000200c34:	00008717          	auipc	a4,0x8
ffffffe000200c38:	3fc70713          	addi	a4,a4,1020 # ffffffe000209030 <task>
ffffffe000200c3c:	fdc42783          	lw	a5,-36(s0)
ffffffe000200c40:	00379793          	slli	a5,a5,0x3
ffffffe000200c44:	00f707b3          	add	a5,a4,a5
ffffffe000200c48:	0007b783          	ld	a5,0(a5)
ffffffe000200c4c:	fffff717          	auipc	a4,0xfffff
ffffffe000200c50:	4f870713          	addi	a4,a4,1272 # ffffffe000200144 <__dummy>
ffffffe000200c54:	02e7b023          	sd	a4,32(a5)
        task[i]->thread.sp = (uint64_t)task[i] + PGSIZE;
ffffffe000200c58:	00008717          	auipc	a4,0x8
ffffffe000200c5c:	3d870713          	addi	a4,a4,984 # ffffffe000209030 <task>
ffffffe000200c60:	fdc42783          	lw	a5,-36(s0)
ffffffe000200c64:	00379793          	slli	a5,a5,0x3
ffffffe000200c68:	00f707b3          	add	a5,a4,a5
ffffffe000200c6c:	0007b783          	ld	a5,0(a5)
ffffffe000200c70:	00078693          	mv	a3,a5
ffffffe000200c74:	00008717          	auipc	a4,0x8
ffffffe000200c78:	3bc70713          	addi	a4,a4,956 # ffffffe000209030 <task>
ffffffe000200c7c:	fdc42783          	lw	a5,-36(s0)
ffffffe000200c80:	00379793          	slli	a5,a5,0x3
ffffffe000200c84:	00f707b3          	add	a5,a4,a5
ffffffe000200c88:	0007b783          	ld	a5,0(a5)
ffffffe000200c8c:	00001737          	lui	a4,0x1
ffffffe000200c90:	00e68733          	add	a4,a3,a4
ffffffe000200c94:	02e7b423          	sd	a4,40(a5)

        // 用户态相关设置
        // 设置kernel stack和user stack
        task[i]->kernel_sp = (uint64_t)task[i] + PGSIZE;
ffffffe000200c98:	00008717          	auipc	a4,0x8
ffffffe000200c9c:	39870713          	addi	a4,a4,920 # ffffffe000209030 <task>
ffffffe000200ca0:	fdc42783          	lw	a5,-36(s0)
ffffffe000200ca4:	00379793          	slli	a5,a5,0x3
ffffffe000200ca8:	00f707b3          	add	a5,a4,a5
ffffffe000200cac:	0007b783          	ld	a5,0(a5)
ffffffe000200cb0:	00078693          	mv	a3,a5
ffffffe000200cb4:	00008717          	auipc	a4,0x8
ffffffe000200cb8:	37c70713          	addi	a4,a4,892 # ffffffe000209030 <task>
ffffffe000200cbc:	fdc42783          	lw	a5,-36(s0)
ffffffe000200cc0:	00379793          	slli	a5,a5,0x3
ffffffe000200cc4:	00f707b3          	add	a5,a4,a5
ffffffe000200cc8:	0007b783          	ld	a5,0(a5)
ffffffe000200ccc:	00001737          	lui	a4,0x1
ffffffe000200cd0:	00e68733          	add	a4,a3,a4
ffffffe000200cd4:	0ae7bc23          	sd	a4,184(a5)
        // task[i]->user_sp = alloc_page(); // 新分配一个page
        uint64_t* new_pgtbl = (uint64_t*)alloc_page(); // 新分配一个pgtbl
ffffffe000200cd8:	c55ff0ef          	jal	ffffffe00020092c <alloc_page>
ffffffe000200cdc:	fca43823          	sd	a0,-48(s0)
        memcpy(new_pgtbl, swapper_pg_dir, PGSIZE);
ffffffe000200ce0:	00001637          	lui	a2,0x1
ffffffe000200ce4:	0000a597          	auipc	a1,0xa
ffffffe000200ce8:	31c58593          	addi	a1,a1,796 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000200cec:	fd043503          	ld	a0,-48(s0)
ffffffe000200cf0:	1bd020ef          	jal	ffffffe0002036ac <memcpy>
        task[i]->pgd = new_pgtbl;
ffffffe000200cf4:	00008717          	auipc	a4,0x8
ffffffe000200cf8:	33c70713          	addi	a4,a4,828 # ffffffe000209030 <task>
ffffffe000200cfc:	fdc42783          	lw	a5,-36(s0)
ffffffe000200d00:	00379793          	slli	a5,a5,0x3
ffffffe000200d04:	00f707b3          	add	a5,a4,a5
ffffffe000200d08:	0007b783          	ld	a5,0(a5)
ffffffe000200d0c:	fd043703          	ld	a4,-48(s0)
ffffffe000200d10:	0ae7b823          	sd	a4,176(a5)
//        pa = task[i]->user_sp - PA2VA_OFFSET;
//        va = USER_END - PGSIZE;
//        create_mapping(task[i]->pgd, va, pa, PGSIZE, 0x17); // 映射stack

        // 使用 do_mmap 来为用户程序段和栈分配 VMA
        Elf64_Ehdr *ehdr = (Elf64_Ehdr *)_sramdisk;
ffffffe000200d14:	00005797          	auipc	a5,0x5
ffffffe000200d18:	2ec78793          	addi	a5,a5,748 # ffffffe000206000 <_sramdisk>
ffffffe000200d1c:	fcf43423          	sd	a5,-56(s0)
        Elf64_Phdr *phdrs = (Elf64_Phdr *)(_sramdisk + ehdr->e_phoff);
ffffffe000200d20:	fc843783          	ld	a5,-56(s0)
ffffffe000200d24:	0207b703          	ld	a4,32(a5)
ffffffe000200d28:	00005797          	auipc	a5,0x5
ffffffe000200d2c:	2d878793          	addi	a5,a5,728 # ffffffe000206000 <_sramdisk>
ffffffe000200d30:	00f707b3          	add	a5,a4,a5
ffffffe000200d34:	fcf43023          	sd	a5,-64(s0)
        task[i]->mm = (struct mm_struct*)kalloc();
ffffffe000200d38:	00008717          	auipc	a4,0x8
ffffffe000200d3c:	2f870713          	addi	a4,a4,760 # ffffffe000209030 <task>
ffffffe000200d40:	fdc42783          	lw	a5,-36(s0)
ffffffe000200d44:	00379793          	slli	a5,a5,0x3
ffffffe000200d48:	00f707b3          	add	a5,a4,a5
ffffffe000200d4c:	0007b483          	ld	s1,0(a5)
ffffffe000200d50:	c51ff0ef          	jal	ffffffe0002009a0 <kalloc>
ffffffe000200d54:	00050793          	mv	a5,a0
ffffffe000200d58:	0cf4b423          	sd	a5,200(s1)
        task[i]->mm->mmap = NULL;
ffffffe000200d5c:	00008717          	auipc	a4,0x8
ffffffe000200d60:	2d470713          	addi	a4,a4,724 # ffffffe000209030 <task>
ffffffe000200d64:	fdc42783          	lw	a5,-36(s0)
ffffffe000200d68:	00379793          	slli	a5,a5,0x3
ffffffe000200d6c:	00f707b3          	add	a5,a4,a5
ffffffe000200d70:	0007b783          	ld	a5,0(a5)
ffffffe000200d74:	0c87b783          	ld	a5,200(a5)
ffffffe000200d78:	0007b023          	sd	zero,0(a5)
         // 对于elf中的每个section
        for (int k = 0; k < ehdr->e_phnum; ++k) {
ffffffe000200d7c:	fc042c23          	sw	zero,-40(s0)
ffffffe000200d80:	0a80006f          	j	ffffffe000200e28 <task_init+0x37c>
            Elf64_Phdr *phdr = phdrs + k;
ffffffe000200d84:	fd842703          	lw	a4,-40(s0)
ffffffe000200d88:	00070793          	mv	a5,a4
ffffffe000200d8c:	00379793          	slli	a5,a5,0x3
ffffffe000200d90:	40e787b3          	sub	a5,a5,a4
ffffffe000200d94:	00379793          	slli	a5,a5,0x3
ffffffe000200d98:	00078713          	mv	a4,a5
ffffffe000200d9c:	fc043783          	ld	a5,-64(s0)
ffffffe000200da0:	00e787b3          	add	a5,a5,a4
ffffffe000200da4:	f8f43c23          	sd	a5,-104(s0)
            if (phdr->p_type == PT_LOAD) {
ffffffe000200da8:	f9843783          	ld	a5,-104(s0)
ffffffe000200dac:	0007a783          	lw	a5,0(a5)
ffffffe000200db0:	00078713          	mv	a4,a5
ffffffe000200db4:	00100793          	li	a5,1
ffffffe000200db8:	06f71263          	bne	a4,a5,ffffffe000200e1c <task_init+0x370>
                uint64_t flags = phdr->p_flags << 1; // phdr的flag和vma中的flag不一样
ffffffe000200dbc:	f9843783          	ld	a5,-104(s0)
ffffffe000200dc0:	0047a783          	lw	a5,4(a5)
ffffffe000200dc4:	0017979b          	slliw	a5,a5,0x1
ffffffe000200dc8:	0007879b          	sext.w	a5,a5
ffffffe000200dcc:	02079793          	slli	a5,a5,0x20
ffffffe000200dd0:	0207d793          	srli	a5,a5,0x20
ffffffe000200dd4:	f8f43823          	sd	a5,-112(s0)
                do_mmap(task[i]->mm, phdr->p_vaddr, phdr->p_memsz, phdr->p_offset, phdr->p_filesz, flags);
ffffffe000200dd8:	00008717          	auipc	a4,0x8
ffffffe000200ddc:	25870713          	addi	a4,a4,600 # ffffffe000209030 <task>
ffffffe000200de0:	fdc42783          	lw	a5,-36(s0)
ffffffe000200de4:	00379793          	slli	a5,a5,0x3
ffffffe000200de8:	00f707b3          	add	a5,a4,a5
ffffffe000200dec:	0007b783          	ld	a5,0(a5)
ffffffe000200df0:	0c87b503          	ld	a0,200(a5)
ffffffe000200df4:	f9843783          	ld	a5,-104(s0)
ffffffe000200df8:	0107b583          	ld	a1,16(a5)
ffffffe000200dfc:	f9843783          	ld	a5,-104(s0)
ffffffe000200e00:	0287b603          	ld	a2,40(a5)
ffffffe000200e04:	f9843783          	ld	a5,-104(s0)
ffffffe000200e08:	0087b683          	ld	a3,8(a5)
ffffffe000200e0c:	f9843783          	ld	a5,-104(s0)
ffffffe000200e10:	0207b703          	ld	a4,32(a5)
ffffffe000200e14:	f9043783          	ld	a5,-112(s0)
ffffffe000200e18:	029000ef          	jal	ffffffe000201640 <do_mmap>
        for (int k = 0; k < ehdr->e_phnum; ++k) {
ffffffe000200e1c:	fd842783          	lw	a5,-40(s0)
ffffffe000200e20:	0017879b          	addiw	a5,a5,1
ffffffe000200e24:	fcf42c23          	sw	a5,-40(s0)
ffffffe000200e28:	fc843783          	ld	a5,-56(s0)
ffffffe000200e2c:	0387d783          	lhu	a5,56(a5)
ffffffe000200e30:	0007871b          	sext.w	a4,a5
ffffffe000200e34:	fd842783          	lw	a5,-40(s0)
ffffffe000200e38:	0007879b          	sext.w	a5,a5
ffffffe000200e3c:	f4e7c4e3          	blt	a5,a4,ffffffe000200d84 <task_init+0x2d8>
            }
        }
        do_mmap(task[i]->mm, USER_END - PGSIZE, PGSIZE, 0, 0, VM_READ | VM_WRITE | VM_ANON); // 用户栈
ffffffe000200e40:	00008717          	auipc	a4,0x8
ffffffe000200e44:	1f070713          	addi	a4,a4,496 # ffffffe000209030 <task>
ffffffe000200e48:	fdc42783          	lw	a5,-36(s0)
ffffffe000200e4c:	00379793          	slli	a5,a5,0x3
ffffffe000200e50:	00f707b3          	add	a5,a4,a5
ffffffe000200e54:	0007b783          	ld	a5,0(a5)
ffffffe000200e58:	0c87b503          	ld	a0,200(a5)
ffffffe000200e5c:	00700793          	li	a5,7
ffffffe000200e60:	00000713          	li	a4,0
ffffffe000200e64:	00000693          	li	a3,0
ffffffe000200e68:	00001637          	lui	a2,0x1
ffffffe000200e6c:	040005b7          	lui	a1,0x4000
ffffffe000200e70:	fff58593          	addi	a1,a1,-1 # 3ffffff <TIMECLOCK+0x367697f>
ffffffe000200e74:	00c59593          	slli	a1,a1,0xc
ffffffe000200e78:	7c8000ef          	jal	ffffffe000201640 <do_mmap>

        // 更新各种寄存器：sepc, sstatus, sscratch, satp
        task[i]->thread.sepc = ehdr->e_entry; // 记得设置sepc!!
ffffffe000200e7c:	00008717          	auipc	a4,0x8
ffffffe000200e80:	1b470713          	addi	a4,a4,436 # ffffffe000209030 <task>
ffffffe000200e84:	fdc42783          	lw	a5,-36(s0)
ffffffe000200e88:	00379793          	slli	a5,a5,0x3
ffffffe000200e8c:	00f707b3          	add	a5,a4,a5
ffffffe000200e90:	0007b783          	ld	a5,0(a5)
ffffffe000200e94:	fc843703          	ld	a4,-56(s0)
ffffffe000200e98:	01873703          	ld	a4,24(a4)
ffffffe000200e9c:	08e7b823          	sd	a4,144(a5)
        uint64_t sstatus = task[i]->thread.sstatus;
ffffffe000200ea0:	00008717          	auipc	a4,0x8
ffffffe000200ea4:	19070713          	addi	a4,a4,400 # ffffffe000209030 <task>
ffffffe000200ea8:	fdc42783          	lw	a5,-36(s0)
ffffffe000200eac:	00379793          	slli	a5,a5,0x3
ffffffe000200eb0:	00f707b3          	add	a5,a4,a5
ffffffe000200eb4:	0007b783          	ld	a5,0(a5)
ffffffe000200eb8:	0987b783          	ld	a5,152(a5)
ffffffe000200ebc:	faf43c23          	sd	a5,-72(s0)
        sstatus &= ~(1 << 8);
ffffffe000200ec0:	fb843783          	ld	a5,-72(s0)
ffffffe000200ec4:	eff7f793          	andi	a5,a5,-257
ffffffe000200ec8:	faf43c23          	sd	a5,-72(s0)
        sstatus |= (1 << 5);
ffffffe000200ecc:	fb843783          	ld	a5,-72(s0)
ffffffe000200ed0:	0207e793          	ori	a5,a5,32
ffffffe000200ed4:	faf43c23          	sd	a5,-72(s0)
        sstatus |= (1 << 18);
ffffffe000200ed8:	fb843703          	ld	a4,-72(s0)
ffffffe000200edc:	000407b7          	lui	a5,0x40
ffffffe000200ee0:	00f767b3          	or	a5,a4,a5
ffffffe000200ee4:	faf43c23          	sd	a5,-72(s0)
        task[i]->thread.sstatus = sstatus;
ffffffe000200ee8:	00008717          	auipc	a4,0x8
ffffffe000200eec:	14870713          	addi	a4,a4,328 # ffffffe000209030 <task>
ffffffe000200ef0:	fdc42783          	lw	a5,-36(s0)
ffffffe000200ef4:	00379793          	slli	a5,a5,0x3
ffffffe000200ef8:	00f707b3          	add	a5,a4,a5
ffffffe000200efc:	0007b783          	ld	a5,0(a5) # 40000 <PGSIZE+0x3f000>
ffffffe000200f00:	fb843703          	ld	a4,-72(s0)
ffffffe000200f04:	08e7bc23          	sd	a4,152(a5)
        task[i]->thread.sscratch = USER_END;
ffffffe000200f08:	00008717          	auipc	a4,0x8
ffffffe000200f0c:	12870713          	addi	a4,a4,296 # ffffffe000209030 <task>
ffffffe000200f10:	fdc42783          	lw	a5,-36(s0)
ffffffe000200f14:	00379793          	slli	a5,a5,0x3
ffffffe000200f18:	00f707b3          	add	a5,a4,a5
ffffffe000200f1c:	0007b783          	ld	a5,0(a5)
ffffffe000200f20:	00100713          	li	a4,1
ffffffe000200f24:	02671713          	slli	a4,a4,0x26
ffffffe000200f28:	0ae7b023          	sd	a4,160(a5)
        uint64_t curr_pgd = (uint64_t)(task[i]->pgd);
ffffffe000200f2c:	00008717          	auipc	a4,0x8
ffffffe000200f30:	10470713          	addi	a4,a4,260 # ffffffe000209030 <task>
ffffffe000200f34:	fdc42783          	lw	a5,-36(s0)
ffffffe000200f38:	00379793          	slli	a5,a5,0x3
ffffffe000200f3c:	00f707b3          	add	a5,a4,a5
ffffffe000200f40:	0007b783          	ld	a5,0(a5)
ffffffe000200f44:	0b07b783          	ld	a5,176(a5)
ffffffe000200f48:	faf43823          	sd	a5,-80(s0)
        uint64_t curr_satp = csr_read(satp);
ffffffe000200f4c:	180027f3          	csrr	a5,satp
ffffffe000200f50:	faf43423          	sd	a5,-88(s0)
ffffffe000200f54:	fa843783          	ld	a5,-88(s0)
ffffffe000200f58:	faf43023          	sd	a5,-96(s0)
        curr_satp = (curr_satp >> 44) << 44; // 清除信息
ffffffe000200f5c:	fa043703          	ld	a4,-96(s0)
ffffffe000200f60:	fff00793          	li	a5,-1
ffffffe000200f64:	02c79793          	slli	a5,a5,0x2c
ffffffe000200f68:	00f777b3          	and	a5,a4,a5
ffffffe000200f6c:	faf43023          	sd	a5,-96(s0)
        curr_satp |= ((curr_pgd - PA2VA_OFFSET) >> 12); // 写入当前task的PPN
ffffffe000200f70:	fb043703          	ld	a4,-80(s0)
ffffffe000200f74:	04100793          	li	a5,65
ffffffe000200f78:	01f79793          	slli	a5,a5,0x1f
ffffffe000200f7c:	00f707b3          	add	a5,a4,a5
ffffffe000200f80:	00c7d793          	srli	a5,a5,0xc
ffffffe000200f84:	fa043703          	ld	a4,-96(s0)
ffffffe000200f88:	00f767b3          	or	a5,a4,a5
ffffffe000200f8c:	faf43023          	sd	a5,-96(s0)
        curr_satp |= (0x8 << 60); // 设置格式
        task[i]->satp = curr_satp;
ffffffe000200f90:	00008717          	auipc	a4,0x8
ffffffe000200f94:	0a070713          	addi	a4,a4,160 # ffffffe000209030 <task>
ffffffe000200f98:	fdc42783          	lw	a5,-36(s0)
ffffffe000200f9c:	00379793          	slli	a5,a5,0x3
ffffffe000200fa0:	00f707b3          	add	a5,a4,a5
ffffffe000200fa4:	0007b783          	ld	a5,0(a5)
ffffffe000200fa8:	fa043703          	ld	a4,-96(s0)
ffffffe000200fac:	0ae7b423          	sd	a4,168(a5)
    for (int i = 1; i < NR_TASKS; i++){
ffffffe000200fb0:	fdc42783          	lw	a5,-36(s0)
ffffffe000200fb4:	0017879b          	addiw	a5,a5,1
ffffffe000200fb8:	fcf42e23          	sw	a5,-36(s0)
ffffffe000200fbc:	fdc42783          	lw	a5,-36(s0)
ffffffe000200fc0:	0007871b          	sext.w	a4,a5
ffffffe000200fc4:	00400793          	li	a5,4
ffffffe000200fc8:	bae7dae3          	bge	a5,a4,ffffffe000200b7c <task_init+0xd0>
        // load_program(task[i]);
    }
    printk("...task_init done!\n");
ffffffe000200fcc:	00003517          	auipc	a0,0x3
ffffffe000200fd0:	07450513          	addi	a0,a0,116 # ffffffe000204040 <_srodata+0x40>
ffffffe000200fd4:	548020ef          	jal	ffffffe00020351c <printk>
    return;
ffffffe000200fd8:	00000013          	nop
}
ffffffe000200fdc:	06813083          	ld	ra,104(sp)
ffffffe000200fe0:	06013403          	ld	s0,96(sp)
ffffffe000200fe4:	05813483          	ld	s1,88(sp)
ffffffe000200fe8:	07010113          	addi	sp,sp,112
ffffffe000200fec:	00008067          	ret

ffffffe000200ff0 <switch_to>:
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif
extern void __switch_to(struct task_struct *prev, struct task_struct *next);

void switch_to(struct task_struct *next) {
ffffffe000200ff0:	fd010113          	addi	sp,sp,-48
ffffffe000200ff4:	02113423          	sd	ra,40(sp)
ffffffe000200ff8:	02813023          	sd	s0,32(sp)
ffffffe000200ffc:	03010413          	addi	s0,sp,48
ffffffe000201000:	fca43c23          	sd	a0,-40(s0)
    // YOUR CODE HERE
    if (current->pid == next->pid){
ffffffe000201004:	00008797          	auipc	a5,0x8
ffffffe000201008:	00c78793          	addi	a5,a5,12 # ffffffe000209010 <current>
ffffffe00020100c:	0007b783          	ld	a5,0(a5)
ffffffe000201010:	0187b703          	ld	a4,24(a5)
ffffffe000201014:	fd843783          	ld	a5,-40(s0)
ffffffe000201018:	0187b783          	ld	a5,24(a5)
ffffffe00020101c:	02f70a63          	beq	a4,a5,ffffffe000201050 <switch_to+0x60>
        return;
    }
    struct task_struct*tmp = current;
ffffffe000201020:	00008797          	auipc	a5,0x8
ffffffe000201024:	ff078793          	addi	a5,a5,-16 # ffffffe000209010 <current>
ffffffe000201028:	0007b783          	ld	a5,0(a5)
ffffffe00020102c:	fef43423          	sd	a5,-24(s0)
    current = next ;
ffffffe000201030:	00008797          	auipc	a5,0x8
ffffffe000201034:	fe078793          	addi	a5,a5,-32 # ffffffe000209010 <current>
ffffffe000201038:	fd843703          	ld	a4,-40(s0)
ffffffe00020103c:	00e7b023          	sd	a4,0(a5)
    __switch_to(tmp, next);
ffffffe000201040:	fd843583          	ld	a1,-40(s0)
ffffffe000201044:	fe843503          	ld	a0,-24(s0)
ffffffe000201048:	83cff0ef          	jal	ffffffe000200084 <__switch_to>
ffffffe00020104c:	0080006f          	j	ffffffe000201054 <switch_to+0x64>
        return;
ffffffe000201050:	00000013          	nop
}
ffffffe000201054:	02813083          	ld	ra,40(sp)
ffffffe000201058:	02013403          	ld	s0,32(sp)
ffffffe00020105c:	03010113          	addi	sp,sp,48
ffffffe000201060:	00008067          	ret

ffffffe000201064 <dummy>:

void dummy() {
ffffffe000201064:	fd010113          	addi	sp,sp,-48
ffffffe000201068:	02113423          	sd	ra,40(sp)
ffffffe00020106c:	02813023          	sd	s0,32(sp)
ffffffe000201070:	03010413          	addi	s0,sp,48
    // printk("enter dummy\n");
    uint64_t MOD = 1000000007;
ffffffe000201074:	3b9ad7b7          	lui	a5,0x3b9ad
ffffffe000201078:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <PHY_SIZE+0x339aca07>
ffffffe00020107c:	fcf43c23          	sd	a5,-40(s0)
    uint64_t auto_inc_local_var = 0;
ffffffe000201080:	fe043423          	sd	zero,-24(s0)
    int last_counter = -1;
ffffffe000201084:	fff00793          	li	a5,-1
ffffffe000201088:	fef42223          	sw	a5,-28(s0)
    // printk("current->counter =%d\n ", current->counter);
    while (1) {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
ffffffe00020108c:	fe442783          	lw	a5,-28(s0)
ffffffe000201090:	0007871b          	sext.w	a4,a5
ffffffe000201094:	fff00793          	li	a5,-1
ffffffe000201098:	00f70e63          	beq	a4,a5,ffffffe0002010b4 <dummy+0x50>
ffffffe00020109c:	00008797          	auipc	a5,0x8
ffffffe0002010a0:	f7478793          	addi	a5,a5,-140 # ffffffe000209010 <current>
ffffffe0002010a4:	0007b783          	ld	a5,0(a5)
ffffffe0002010a8:	0087b703          	ld	a4,8(a5)
ffffffe0002010ac:	fe442783          	lw	a5,-28(s0)
ffffffe0002010b0:	fcf70ee3          	beq	a4,a5,ffffffe00020108c <dummy+0x28>
ffffffe0002010b4:	00008797          	auipc	a5,0x8
ffffffe0002010b8:	f5c78793          	addi	a5,a5,-164 # ffffffe000209010 <current>
ffffffe0002010bc:	0007b783          	ld	a5,0(a5)
ffffffe0002010c0:	0087b783          	ld	a5,8(a5)
ffffffe0002010c4:	fc0784e3          	beqz	a5,ffffffe00020108c <dummy+0x28>
            if (current->counter == 1) {
ffffffe0002010c8:	00008797          	auipc	a5,0x8
ffffffe0002010cc:	f4878793          	addi	a5,a5,-184 # ffffffe000209010 <current>
ffffffe0002010d0:	0007b783          	ld	a5,0(a5)
ffffffe0002010d4:	0087b703          	ld	a4,8(a5)
ffffffe0002010d8:	00100793          	li	a5,1
ffffffe0002010dc:	00f71e63          	bne	a4,a5,ffffffe0002010f8 <dummy+0x94>
                --(current->counter);   // forced the counter to be zero if this thread is going to be scheduled
ffffffe0002010e0:	00008797          	auipc	a5,0x8
ffffffe0002010e4:	f3078793          	addi	a5,a5,-208 # ffffffe000209010 <current>
ffffffe0002010e8:	0007b783          	ld	a5,0(a5)
ffffffe0002010ec:	0087b703          	ld	a4,8(a5)
ffffffe0002010f0:	fff70713          	addi	a4,a4,-1
ffffffe0002010f4:	00e7b423          	sd	a4,8(a5)
            }                           // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
ffffffe0002010f8:	00008797          	auipc	a5,0x8
ffffffe0002010fc:	f1878793          	addi	a5,a5,-232 # ffffffe000209010 <current>
ffffffe000201100:	0007b783          	ld	a5,0(a5)
ffffffe000201104:	0087b783          	ld	a5,8(a5)
ffffffe000201108:	fef42223          	sw	a5,-28(s0)
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
ffffffe00020110c:	fe843783          	ld	a5,-24(s0)
ffffffe000201110:	00178713          	addi	a4,a5,1
ffffffe000201114:	fd843783          	ld	a5,-40(s0)
ffffffe000201118:	02f777b3          	remu	a5,a4,a5
ffffffe00020111c:	fef43423          	sd	a5,-24(s0)
            printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
ffffffe000201120:	00008797          	auipc	a5,0x8
ffffffe000201124:	ef078793          	addi	a5,a5,-272 # ffffffe000209010 <current>
ffffffe000201128:	0007b783          	ld	a5,0(a5)
ffffffe00020112c:	0187b783          	ld	a5,24(a5)
ffffffe000201130:	fe843603          	ld	a2,-24(s0)
ffffffe000201134:	00078593          	mv	a1,a5
ffffffe000201138:	00003517          	auipc	a0,0x3
ffffffe00020113c:	f2050513          	addi	a0,a0,-224 # ffffffe000204058 <_srodata+0x58>
ffffffe000201140:	3dc020ef          	jal	ffffffe00020351c <printk>
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
ffffffe000201144:	f49ff06f          	j	ffffffe00020108c <dummy+0x28>

ffffffe000201148 <schedule>:
            #endif
        }
    }
}

void schedule() {
ffffffe000201148:	fd010113          	addi	sp,sp,-48
ffffffe00020114c:	02113423          	sd	ra,40(sp)
ffffffe000201150:	02813023          	sd	s0,32(sp)
ffffffe000201154:	03010413          	addi	s0,sp,48
    struct task_struct* next = current;
ffffffe000201158:	00008797          	auipc	a5,0x8
ffffffe00020115c:	eb878793          	addi	a5,a5,-328 # ffffffe000209010 <current>
ffffffe000201160:	0007b783          	ld	a5,0(a5)
ffffffe000201164:	fef43423          	sd	a5,-24(s0)
    uint64_t max = 0;
ffffffe000201168:	fe043023          	sd	zero,-32(s0)
    // 查找具有最大 counter 值的线程，如果没有，则reschedule并且继续查找
    while (1){
        for (int i = 0; i < NR_TASKS; i++) {
ffffffe00020116c:	fc042e23          	sw	zero,-36(s0)
ffffffe000201170:	0b00006f          	j	ffffffe000201220 <schedule+0xd8>
            if (task[i]->state == TASK_RUNNING && task[i]->counter > 0){
ffffffe000201174:	00008717          	auipc	a4,0x8
ffffffe000201178:	ebc70713          	addi	a4,a4,-324 # ffffffe000209030 <task>
ffffffe00020117c:	fdc42783          	lw	a5,-36(s0)
ffffffe000201180:	00379793          	slli	a5,a5,0x3
ffffffe000201184:	00f707b3          	add	a5,a4,a5
ffffffe000201188:	0007b783          	ld	a5,0(a5)
ffffffe00020118c:	0007b783          	ld	a5,0(a5)
ffffffe000201190:	08079263          	bnez	a5,ffffffe000201214 <schedule+0xcc>
ffffffe000201194:	00008717          	auipc	a4,0x8
ffffffe000201198:	e9c70713          	addi	a4,a4,-356 # ffffffe000209030 <task>
ffffffe00020119c:	fdc42783          	lw	a5,-36(s0)
ffffffe0002011a0:	00379793          	slli	a5,a5,0x3
ffffffe0002011a4:	00f707b3          	add	a5,a4,a5
ffffffe0002011a8:	0007b783          	ld	a5,0(a5)
ffffffe0002011ac:	0087b783          	ld	a5,8(a5)
ffffffe0002011b0:	06078263          	beqz	a5,ffffffe000201214 <schedule+0xcc>
                if (task[i]->counter > max){
ffffffe0002011b4:	00008717          	auipc	a4,0x8
ffffffe0002011b8:	e7c70713          	addi	a4,a4,-388 # ffffffe000209030 <task>
ffffffe0002011bc:	fdc42783          	lw	a5,-36(s0)
ffffffe0002011c0:	00379793          	slli	a5,a5,0x3
ffffffe0002011c4:	00f707b3          	add	a5,a4,a5
ffffffe0002011c8:	0007b783          	ld	a5,0(a5)
ffffffe0002011cc:	0087b783          	ld	a5,8(a5)
ffffffe0002011d0:	fe043703          	ld	a4,-32(s0)
ffffffe0002011d4:	04f77063          	bgeu	a4,a5,ffffffe000201214 <schedule+0xcc>
                    max = task[i]->counter;
ffffffe0002011d8:	00008717          	auipc	a4,0x8
ffffffe0002011dc:	e5870713          	addi	a4,a4,-424 # ffffffe000209030 <task>
ffffffe0002011e0:	fdc42783          	lw	a5,-36(s0)
ffffffe0002011e4:	00379793          	slli	a5,a5,0x3
ffffffe0002011e8:	00f707b3          	add	a5,a4,a5
ffffffe0002011ec:	0007b783          	ld	a5,0(a5)
ffffffe0002011f0:	0087b783          	ld	a5,8(a5)
ffffffe0002011f4:	fef43023          	sd	a5,-32(s0)
                    next = task[i];
ffffffe0002011f8:	00008717          	auipc	a4,0x8
ffffffe0002011fc:	e3870713          	addi	a4,a4,-456 # ffffffe000209030 <task>
ffffffe000201200:	fdc42783          	lw	a5,-36(s0)
ffffffe000201204:	00379793          	slli	a5,a5,0x3
ffffffe000201208:	00f707b3          	add	a5,a4,a5
ffffffe00020120c:	0007b783          	ld	a5,0(a5)
ffffffe000201210:	fef43423          	sd	a5,-24(s0)
        for (int i = 0; i < NR_TASKS; i++) {
ffffffe000201214:	fdc42783          	lw	a5,-36(s0)
ffffffe000201218:	0017879b          	addiw	a5,a5,1
ffffffe00020121c:	fcf42e23          	sw	a5,-36(s0)
ffffffe000201220:	fdc42783          	lw	a5,-36(s0)
ffffffe000201224:	0007871b          	sext.w	a4,a5
ffffffe000201228:	00400793          	li	a5,4
ffffffe00020122c:	f4e7d4e3          	bge	a5,a4,ffffffe000201174 <schedule+0x2c>
                }
            }
        }
        if (max > 0){
ffffffe000201230:	fe043783          	ld	a5,-32(s0)
ffffffe000201234:	0c079663          	bnez	a5,ffffffe000201300 <schedule+0x1b8>
            break;
        } else {
            // 如果没有找到具有正 counter 的线程，则重新初始化所有线程的 counter
            for (int i = 1; i < NR_TASKS; i++) {
ffffffe000201238:	00100793          	li	a5,1
ffffffe00020123c:	fcf42c23          	sw	a5,-40(s0)
ffffffe000201240:	0ac0006f          	j	ffffffe0002012ec <schedule+0x1a4>
                // 如果所有线程 counter 都为 0，则令所有线程 counter = priority
                task[i]->counter = task[i]->priority;
ffffffe000201244:	00008717          	auipc	a4,0x8
ffffffe000201248:	dec70713          	addi	a4,a4,-532 # ffffffe000209030 <task>
ffffffe00020124c:	fd842783          	lw	a5,-40(s0)
ffffffe000201250:	00379793          	slli	a5,a5,0x3
ffffffe000201254:	00f707b3          	add	a5,a4,a5
ffffffe000201258:	0007b703          	ld	a4,0(a5)
ffffffe00020125c:	00008697          	auipc	a3,0x8
ffffffe000201260:	dd468693          	addi	a3,a3,-556 # ffffffe000209030 <task>
ffffffe000201264:	fd842783          	lw	a5,-40(s0)
ffffffe000201268:	00379793          	slli	a5,a5,0x3
ffffffe00020126c:	00f687b3          	add	a5,a3,a5
ffffffe000201270:	0007b783          	ld	a5,0(a5)
ffffffe000201274:	01073703          	ld	a4,16(a4)
ffffffe000201278:	00e7b423          	sd	a4,8(a5)
                // 重新调度
                printk("SET [PID = %d PRIORITY = %d COUNTER = %d]\n", task[i]->pid, task[i]->priority, task[i]->counter);
ffffffe00020127c:	00008717          	auipc	a4,0x8
ffffffe000201280:	db470713          	addi	a4,a4,-588 # ffffffe000209030 <task>
ffffffe000201284:	fd842783          	lw	a5,-40(s0)
ffffffe000201288:	00379793          	slli	a5,a5,0x3
ffffffe00020128c:	00f707b3          	add	a5,a4,a5
ffffffe000201290:	0007b783          	ld	a5,0(a5)
ffffffe000201294:	0187b583          	ld	a1,24(a5)
ffffffe000201298:	00008717          	auipc	a4,0x8
ffffffe00020129c:	d9870713          	addi	a4,a4,-616 # ffffffe000209030 <task>
ffffffe0002012a0:	fd842783          	lw	a5,-40(s0)
ffffffe0002012a4:	00379793          	slli	a5,a5,0x3
ffffffe0002012a8:	00f707b3          	add	a5,a4,a5
ffffffe0002012ac:	0007b783          	ld	a5,0(a5)
ffffffe0002012b0:	0107b603          	ld	a2,16(a5)
ffffffe0002012b4:	00008717          	auipc	a4,0x8
ffffffe0002012b8:	d7c70713          	addi	a4,a4,-644 # ffffffe000209030 <task>
ffffffe0002012bc:	fd842783          	lw	a5,-40(s0)
ffffffe0002012c0:	00379793          	slli	a5,a5,0x3
ffffffe0002012c4:	00f707b3          	add	a5,a4,a5
ffffffe0002012c8:	0007b783          	ld	a5,0(a5)
ffffffe0002012cc:	0087b783          	ld	a5,8(a5)
ffffffe0002012d0:	00078693          	mv	a3,a5
ffffffe0002012d4:	00003517          	auipc	a0,0x3
ffffffe0002012d8:	db450513          	addi	a0,a0,-588 # ffffffe000204088 <_srodata+0x88>
ffffffe0002012dc:	240020ef          	jal	ffffffe00020351c <printk>
            for (int i = 1; i < NR_TASKS; i++) {
ffffffe0002012e0:	fd842783          	lw	a5,-40(s0)
ffffffe0002012e4:	0017879b          	addiw	a5,a5,1
ffffffe0002012e8:	fcf42c23          	sw	a5,-40(s0)
ffffffe0002012ec:	fd842783          	lw	a5,-40(s0)
ffffffe0002012f0:	0007871b          	sext.w	a4,a5
ffffffe0002012f4:	00400793          	li	a5,4
ffffffe0002012f8:	f4e7d6e3          	bge	a5,a4,ffffffe000201244 <schedule+0xfc>
        for (int i = 0; i < NR_TASKS; i++) {
ffffffe0002012fc:	e71ff06f          	j	ffffffe00020116c <schedule+0x24>
            break;
ffffffe000201300:	00000013          	nop
            }
        }
    }
    // 切换到选定的线程
    printk(BLUE "\nswitch to [PID = %d COUNTER = %d PRIORITY = %d]\n" CLEAR,next->pid,next->counter,next->priority);
ffffffe000201304:	fe843783          	ld	a5,-24(s0)
ffffffe000201308:	0187b703          	ld	a4,24(a5)
ffffffe00020130c:	fe843783          	ld	a5,-24(s0)
ffffffe000201310:	0087b603          	ld	a2,8(a5)
ffffffe000201314:	fe843783          	ld	a5,-24(s0)
ffffffe000201318:	0107b783          	ld	a5,16(a5)
ffffffe00020131c:	00078693          	mv	a3,a5
ffffffe000201320:	00070593          	mv	a1,a4
ffffffe000201324:	00003517          	auipc	a0,0x3
ffffffe000201328:	d9450513          	addi	a0,a0,-620 # ffffffe0002040b8 <_srodata+0xb8>
ffffffe00020132c:	1f0020ef          	jal	ffffffe00020351c <printk>
    switch_to(next);
ffffffe000201330:	fe843503          	ld	a0,-24(s0)
ffffffe000201334:	cbdff0ef          	jal	ffffffe000200ff0 <switch_to>
}
ffffffe000201338:	00000013          	nop
ffffffe00020133c:	02813083          	ld	ra,40(sp)
ffffffe000201340:	02013403          	ld	s0,32(sp)
ffffffe000201344:	03010113          	addi	sp,sp,48
ffffffe000201348:	00008067          	ret

ffffffe00020134c <do_timer>:

void do_timer() {
ffffffe00020134c:	ff010113          	addi	sp,sp,-16
ffffffe000201350:	00113423          	sd	ra,8(sp)
ffffffe000201354:	00813023          	sd	s0,0(sp)
ffffffe000201358:	01010413          	addi	s0,sp,16
    // 1. 如果当前线程是 idle 线程或当前线程时间片耗尽则直接进行调度
    // printk("enter do_timer\n");
    if (current->pid == 0 || current->counter == 0){
ffffffe00020135c:	00008797          	auipc	a5,0x8
ffffffe000201360:	cb478793          	addi	a5,a5,-844 # ffffffe000209010 <current>
ffffffe000201364:	0007b783          	ld	a5,0(a5)
ffffffe000201368:	0187b783          	ld	a5,24(a5)
ffffffe00020136c:	00078c63          	beqz	a5,ffffffe000201384 <do_timer+0x38>
ffffffe000201370:	00008797          	auipc	a5,0x8
ffffffe000201374:	ca078793          	addi	a5,a5,-864 # ffffffe000209010 <current>
ffffffe000201378:	0007b783          	ld	a5,0(a5)
ffffffe00020137c:	0087b783          	ld	a5,8(a5)
ffffffe000201380:	00079663          	bnez	a5,ffffffe00020138c <do_timer+0x40>
        schedule();
ffffffe000201384:	dc5ff0ef          	jal	ffffffe000201148 <schedule>
        return;
ffffffe000201388:	0480006f          	j	ffffffe0002013d0 <do_timer+0x84>
    } else {
        // 2. 否则对当前线程的运行剩余时间减 1，若剩余时间仍然大于 0 则直接返回，否则进行调度
        current->counter -= 1;
ffffffe00020138c:	00008797          	auipc	a5,0x8
ffffffe000201390:	c8478793          	addi	a5,a5,-892 # ffffffe000209010 <current>
ffffffe000201394:	0007b783          	ld	a5,0(a5)
ffffffe000201398:	0087b703          	ld	a4,8(a5)
ffffffe00020139c:	00008797          	auipc	a5,0x8
ffffffe0002013a0:	c7478793          	addi	a5,a5,-908 # ffffffe000209010 <current>
ffffffe0002013a4:	0007b783          	ld	a5,0(a5)
ffffffe0002013a8:	fff70713          	addi	a4,a4,-1
ffffffe0002013ac:	00e7b423          	sd	a4,8(a5)
        if (current->counter > 0) {
ffffffe0002013b0:	00008797          	auipc	a5,0x8
ffffffe0002013b4:	c6078793          	addi	a5,a5,-928 # ffffffe000209010 <current>
ffffffe0002013b8:	0007b783          	ld	a5,0(a5)
ffffffe0002013bc:	0087b783          	ld	a5,8(a5)
ffffffe0002013c0:	00079663          	bnez	a5,ffffffe0002013cc <do_timer+0x80>
            // printk("current task is %d, counter = %d\n", current->pid, current->counter);
            return;
        } else {
            schedule();
ffffffe0002013c4:	d85ff0ef          	jal	ffffffe000201148 <schedule>
ffffffe0002013c8:	0080006f          	j	ffffffe0002013d0 <do_timer+0x84>
            return;
ffffffe0002013cc:	00000013          	nop
        }
    }
}
ffffffe0002013d0:	00813083          	ld	ra,8(sp)
ffffffe0002013d4:	00013403          	ld	s0,0(sp)
ffffffe0002013d8:	01010113          	addi	sp,sp,16
ffffffe0002013dc:	00008067          	ret

ffffffe0002013e0 <load_program>:

// 将elf文件加载入uapp中
static void load_program(struct task_struct *task) {
ffffffe0002013e0:	f8010113          	addi	sp,sp,-128
ffffffe0002013e4:	06113c23          	sd	ra,120(sp)
ffffffe0002013e8:	06813823          	sd	s0,112(sp)
ffffffe0002013ec:	08010413          	addi	s0,sp,128
ffffffe0002013f0:	f8a43423          	sd	a0,-120(s0)
    Elf64_Ehdr *ehdr = (Elf64_Ehdr *)_sramdisk;
ffffffe0002013f4:	00005797          	auipc	a5,0x5
ffffffe0002013f8:	c0c78793          	addi	a5,a5,-1012 # ffffffe000206000 <_sramdisk>
ffffffe0002013fc:	fef43023          	sd	a5,-32(s0)
    Elf64_Phdr *phdrs = (Elf64_Phdr *)(_sramdisk + ehdr->e_phoff);
ffffffe000201400:	fe043783          	ld	a5,-32(s0)
ffffffe000201404:	0207b703          	ld	a4,32(a5)
ffffffe000201408:	00005797          	auipc	a5,0x5
ffffffe00020140c:	bf878793          	addi	a5,a5,-1032 # ffffffe000206000 <_sramdisk>
ffffffe000201410:	00f707b3          	add	a5,a4,a5
ffffffe000201414:	fcf43c23          	sd	a5,-40(s0)
    for (int i = 0; i < ehdr->e_phnum; ++i) {
ffffffe000201418:	fe042623          	sw	zero,-20(s0)
ffffffe00020141c:	1740006f          	j	ffffffe000201590 <load_program+0x1b0>
        // printk("mapping %d-th ehdr into %d-th task\n", i, task->pid);
        Elf64_Phdr *phdr = phdrs + i;
ffffffe000201420:	fec42703          	lw	a4,-20(s0)
ffffffe000201424:	00070793          	mv	a5,a4
ffffffe000201428:	00379793          	slli	a5,a5,0x3
ffffffe00020142c:	40e787b3          	sub	a5,a5,a4
ffffffe000201430:	00379793          	slli	a5,a5,0x3
ffffffe000201434:	00078713          	mv	a4,a5
ffffffe000201438:	fd843783          	ld	a5,-40(s0)
ffffffe00020143c:	00e787b3          	add	a5,a5,a4
ffffffe000201440:	fcf43823          	sd	a5,-48(s0)
        if (phdr->p_type == PT_LOAD) {
ffffffe000201444:	fd043783          	ld	a5,-48(s0)
ffffffe000201448:	0007a783          	lw	a5,0(a5)
ffffffe00020144c:	00078713          	mv	a4,a5
ffffffe000201450:	00100793          	li	a5,1
ffffffe000201454:	12f71863          	bne	a4,a5,ffffffe000201584 <load_program+0x1a4>
            // 计算所需页面数量并分配空间
            uint64_t num_page = ((uint64_t)phdr->p_memsz + PGSIZE - 1) / PGSIZE;
ffffffe000201458:	fd043783          	ld	a5,-48(s0)
ffffffe00020145c:	0287b703          	ld	a4,40(a5)
ffffffe000201460:	000017b7          	lui	a5,0x1
ffffffe000201464:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe000201468:	00f707b3          	add	a5,a4,a5
ffffffe00020146c:	00c7d793          	srli	a5,a5,0xc
ffffffe000201470:	fcf43423          	sd	a5,-56(s0)
            uint64_t *new_space = (uint64_t*)alloc_pages(num_page);
ffffffe000201474:	fc843503          	ld	a0,-56(s0)
ffffffe000201478:	c5cff0ef          	jal	ffffffe0002008d4 <alloc_pages>
ffffffe00020147c:	fca43023          	sd	a0,-64(s0)
            uint64_t filesz = (uint64_t)phdr->p_filesz;
ffffffe000201480:	fd043783          	ld	a5,-48(s0)
ffffffe000201484:	0207b783          	ld	a5,32(a5)
ffffffe000201488:	faf43c23          	sd	a5,-72(s0)
            uint64_t memsz = (uint64_t)phdr->p_memsz;
ffffffe00020148c:	fd043783          	ld	a5,-48(s0)
ffffffe000201490:	0287b783          	ld	a5,40(a5)
ffffffe000201494:	faf43823          	sd	a5,-80(s0)
            uint64_t prem = (phdr->p_flags << 1) | 17;
ffffffe000201498:	fd043783          	ld	a5,-48(s0)
ffffffe00020149c:	0047a783          	lw	a5,4(a5)
ffffffe0002014a0:	0017979b          	slliw	a5,a5,0x1
ffffffe0002014a4:	0007879b          	sext.w	a5,a5
ffffffe0002014a8:	0117e793          	ori	a5,a5,17
ffffffe0002014ac:	0007879b          	sext.w	a5,a5
ffffffe0002014b0:	02079793          	slli	a5,a5,0x20
ffffffe0002014b4:	0207d793          	srli	a5,a5,0x20
ffffffe0002014b8:	faf43423          	sd	a5,-88(s0)
            // 定义offset，使得地址都是页对齐的
            uint64_t start_offset = phdr->p_vaddr - PGROUNDDOWN(phdr->p_vaddr);
ffffffe0002014bc:	fd043783          	ld	a5,-48(s0)
ffffffe0002014c0:	0107b703          	ld	a4,16(a5)
ffffffe0002014c4:	000017b7          	lui	a5,0x1
ffffffe0002014c8:	fff78793          	addi	a5,a5,-1 # fff <PGSIZE-0x1>
ffffffe0002014cc:	00f777b3          	and	a5,a4,a5
ffffffe0002014d0:	faf43023          	sd	a5,-96(s0)
            // 拷贝elf文件到new allocated space
            memcpy((void *)((uint64_t)new_space + start_offset),
ffffffe0002014d4:	fc043703          	ld	a4,-64(s0)
ffffffe0002014d8:	fa043783          	ld	a5,-96(s0)
ffffffe0002014dc:	00f707b3          	add	a5,a4,a5
ffffffe0002014e0:	00078693          	mv	a3,a5
                   (void*)((uint64_t)&_sramdisk + (uint64_t)phdr->p_offset),
ffffffe0002014e4:	fd043783          	ld	a5,-48(s0)
ffffffe0002014e8:	0087b703          	ld	a4,8(a5)
ffffffe0002014ec:	00005797          	auipc	a5,0x5
ffffffe0002014f0:	b1478793          	addi	a5,a5,-1260 # ffffffe000206000 <_sramdisk>
ffffffe0002014f4:	00f707b3          	add	a5,a4,a5
            memcpy((void *)((uint64_t)new_space + start_offset),
ffffffe0002014f8:	fb843603          	ld	a2,-72(s0)
ffffffe0002014fc:	00078593          	mv	a1,a5
ffffffe000201500:	00068513          	mv	a0,a3
ffffffe000201504:	1a8020ef          	jal	ffffffe0002036ac <memcpy>
                   filesz);
            // 如果mem size > file size, 清零多余空间
            memset((void *)((uint64_t)new_space + start_offset + filesz),
ffffffe000201508:	fc043703          	ld	a4,-64(s0)
ffffffe00020150c:	fa043783          	ld	a5,-96(s0)
ffffffe000201510:	00f70733          	add	a4,a4,a5
ffffffe000201514:	fb843783          	ld	a5,-72(s0)
ffffffe000201518:	00f707b3          	add	a5,a4,a5
ffffffe00020151c:	00078693          	mv	a3,a5
                   0,
                   (uint64_t)phdr->p_memsz-filesz);
ffffffe000201520:	fd043783          	ld	a5,-48(s0)
ffffffe000201524:	0287b703          	ld	a4,40(a5)
            memset((void *)((uint64_t)new_space + start_offset + filesz),
ffffffe000201528:	fb843783          	ld	a5,-72(s0)
ffffffe00020152c:	40f707b3          	sub	a5,a4,a5
ffffffe000201530:	00078613          	mv	a2,a5
ffffffe000201534:	00000593          	li	a1,0
ffffffe000201538:	00068513          	mv	a0,a3
ffffffe00020153c:	100020ef          	jal	ffffffe00020363c <memset>
            // create mapping
            uint64_t va = (uint64_t)phdr->p_vaddr;
ffffffe000201540:	fd043783          	ld	a5,-48(s0)
ffffffe000201544:	0107b783          	ld	a5,16(a5)
ffffffe000201548:	f8f43c23          	sd	a5,-104(s0)
            uint64_t pa = (uint64_t)new_space-PA2VA_OFFSET;
ffffffe00020154c:	fc043703          	ld	a4,-64(s0)
ffffffe000201550:	04100793          	li	a5,65
ffffffe000201554:	01f79793          	slli	a5,a5,0x1f
ffffffe000201558:	00f707b3          	add	a5,a4,a5
ffffffe00020155c:	f8f43823          	sd	a5,-112(s0)
            create_mapping(task->pgd, va, pa, num_page*PGSIZE, prem);
ffffffe000201560:	f8843783          	ld	a5,-120(s0)
ffffffe000201564:	0b07b503          	ld	a0,176(a5)
ffffffe000201568:	fc843783          	ld	a5,-56(s0)
ffffffe00020156c:	00c79793          	slli	a5,a5,0xc
ffffffe000201570:	fa843703          	ld	a4,-88(s0)
ffffffe000201574:	00078693          	mv	a3,a5
ffffffe000201578:	f9043603          	ld	a2,-112(s0)
ffffffe00020157c:	f9843583          	ld	a1,-104(s0)
ffffffe000201580:	62d000ef          	jal	ffffffe0002023ac <create_mapping>
    for (int i = 0; i < ehdr->e_phnum; ++i) {
ffffffe000201584:	fec42783          	lw	a5,-20(s0)
ffffffe000201588:	0017879b          	addiw	a5,a5,1
ffffffe00020158c:	fef42623          	sw	a5,-20(s0)
ffffffe000201590:	fe043783          	ld	a5,-32(s0)
ffffffe000201594:	0387d783          	lhu	a5,56(a5)
ffffffe000201598:	0007871b          	sext.w	a4,a5
ffffffe00020159c:	fec42783          	lw	a5,-20(s0)
ffffffe0002015a0:	0007879b          	sext.w	a5,a5
ffffffe0002015a4:	e6e7cee3          	blt	a5,a4,ffffffe000201420 <load_program+0x40>
        }
    }
    task->thread.sepc = ehdr->e_entry;
ffffffe0002015a8:	fe043783          	ld	a5,-32(s0)
ffffffe0002015ac:	0187b703          	ld	a4,24(a5)
ffffffe0002015b0:	f8843783          	ld	a5,-120(s0)
ffffffe0002015b4:	08e7b823          	sd	a4,144(a5)
}
ffffffe0002015b8:	00000013          	nop
ffffffe0002015bc:	07813083          	ld	ra,120(sp)
ffffffe0002015c0:	07013403          	ld	s0,112(sp)
ffffffe0002015c4:	08010113          	addi	sp,sp,128
ffffffe0002015c8:	00008067          	ret

ffffffe0002015cc <find_vma>:

struct vm_area_struct *find_vma(struct mm_struct *mm, uint64_t addr){
ffffffe0002015cc:	fd010113          	addi	sp,sp,-48
ffffffe0002015d0:	02813423          	sd	s0,40(sp)
ffffffe0002015d4:	03010413          	addi	s0,sp,48
ffffffe0002015d8:	fca43c23          	sd	a0,-40(s0)
ffffffe0002015dc:	fcb43823          	sd	a1,-48(s0)
    // printk("Enter find_vma\n");
    struct vm_area_struct *vma = mm->mmap;
ffffffe0002015e0:	fd843783          	ld	a5,-40(s0)
ffffffe0002015e4:	0007b783          	ld	a5,0(a5)
ffffffe0002015e8:	fef43423          	sd	a5,-24(s0)
    while (vma) {
ffffffe0002015ec:	0380006f          	j	ffffffe000201624 <find_vma+0x58>
        // 如果 addr 在 vma 所表示的地址范围内
        if (addr >= vma->vm_start && addr < vma->vm_end) {
ffffffe0002015f0:	fe843783          	ld	a5,-24(s0)
ffffffe0002015f4:	0087b783          	ld	a5,8(a5)
ffffffe0002015f8:	fd043703          	ld	a4,-48(s0)
ffffffe0002015fc:	00f76e63          	bltu	a4,a5,ffffffe000201618 <find_vma+0x4c>
ffffffe000201600:	fe843783          	ld	a5,-24(s0)
ffffffe000201604:	0107b783          	ld	a5,16(a5)
ffffffe000201608:	fd043703          	ld	a4,-48(s0)
ffffffe00020160c:	00f77663          	bgeu	a4,a5,ffffffe000201618 <find_vma+0x4c>
            // printk("vma start = 0x%x, vma end = 0x%x\n", vma->vm_start, vma->vm_end);
            return vma;
ffffffe000201610:	fe843783          	ld	a5,-24(s0)
ffffffe000201614:	01c0006f          	j	ffffffe000201630 <find_vma+0x64>
        }
        vma = vma->vm_next;
ffffffe000201618:	fe843783          	ld	a5,-24(s0)
ffffffe00020161c:	0187b783          	ld	a5,24(a5)
ffffffe000201620:	fef43423          	sd	a5,-24(s0)
    while (vma) {
ffffffe000201624:	fe843783          	ld	a5,-24(s0)
ffffffe000201628:	fc0794e3          	bnez	a5,ffffffe0002015f0 <find_vma+0x24>
    }
    return NULL;
ffffffe00020162c:	00000793          	li	a5,0
}
ffffffe000201630:	00078513          	mv	a0,a5
ffffffe000201634:	02813403          	ld	s0,40(sp)
ffffffe000201638:	03010113          	addi	sp,sp,48
ffffffe00020163c:	00008067          	ret

ffffffe000201640 <do_mmap>:

uint64_t do_mmap(struct mm_struct *mm, uint64_t addr,
        uint64_t len, uint64_t vm_pgoff, uint64_t vm_filesz, uint64_t flags){
ffffffe000201640:	fb010113          	addi	sp,sp,-80
ffffffe000201644:	04113423          	sd	ra,72(sp)
ffffffe000201648:	04813023          	sd	s0,64(sp)
ffffffe00020164c:	05010413          	addi	s0,sp,80
ffffffe000201650:	fca43c23          	sd	a0,-40(s0)
ffffffe000201654:	fcb43823          	sd	a1,-48(s0)
ffffffe000201658:	fcc43423          	sd	a2,-56(s0)
ffffffe00020165c:	fcd43023          	sd	a3,-64(s0)
ffffffe000201660:	fae43c23          	sd	a4,-72(s0)
ffffffe000201664:	faf43823          	sd	a5,-80(s0)
    struct vm_area_struct* vma = (struct vm_area_struct*)kalloc();
ffffffe000201668:	b38ff0ef          	jal	ffffffe0002009a0 <kalloc>
ffffffe00020166c:	fea43023          	sd	a0,-32(s0)
    vma->vm_mm = mm;
ffffffe000201670:	fe043783          	ld	a5,-32(s0)
ffffffe000201674:	fd843703          	ld	a4,-40(s0)
ffffffe000201678:	00e7b023          	sd	a4,0(a5)
    vma->vm_start = addr;
ffffffe00020167c:	fe043783          	ld	a5,-32(s0)
ffffffe000201680:	fd043703          	ld	a4,-48(s0)
ffffffe000201684:	00e7b423          	sd	a4,8(a5)
    vma->vm_end = addr + len;
ffffffe000201688:	fd043703          	ld	a4,-48(s0)
ffffffe00020168c:	fc843783          	ld	a5,-56(s0)
ffffffe000201690:	00f70733          	add	a4,a4,a5
ffffffe000201694:	fe043783          	ld	a5,-32(s0)
ffffffe000201698:	00e7b823          	sd	a4,16(a5)
    vma->vm_pgoff = vm_pgoff;
ffffffe00020169c:	fe043783          	ld	a5,-32(s0)
ffffffe0002016a0:	fc043703          	ld	a4,-64(s0)
ffffffe0002016a4:	02e7b823          	sd	a4,48(a5)
    vma->vm_filesz = vm_filesz;
ffffffe0002016a8:	fe043783          	ld	a5,-32(s0)
ffffffe0002016ac:	fb843703          	ld	a4,-72(s0)
ffffffe0002016b0:	02e7bc23          	sd	a4,56(a5)
    vma->vm_flags = flags;
ffffffe0002016b4:	fe043783          	ld	a5,-32(s0)
ffffffe0002016b8:	fb043703          	ld	a4,-80(s0)
ffffffe0002016bc:	02e7b423          	sd	a4,40(a5)
    vma->vm_next = NULL;
ffffffe0002016c0:	fe043783          	ld	a5,-32(s0)
ffffffe0002016c4:	0007bc23          	sd	zero,24(a5)
    vma->vm_prev = NULL;
ffffffe0002016c8:	fe043783          	ld	a5,-32(s0)
ffffffe0002016cc:	0207b023          	sd	zero,32(a5)

    struct vm_area_struct* current = mm->mmap;
ffffffe0002016d0:	fd843783          	ld	a5,-40(s0)
ffffffe0002016d4:	0007b783          	ld	a5,0(a5)
ffffffe0002016d8:	fef43423          	sd	a5,-24(s0)
    // 当前mm的vma链表为空
    if (current == NULL) {
ffffffe0002016dc:	fe843783          	ld	a5,-24(s0)
ffffffe0002016e0:	02079063          	bnez	a5,ffffffe000201700 <do_mmap+0xc0>
        mm->mmap = vma;
ffffffe0002016e4:	fd843783          	ld	a5,-40(s0)
ffffffe0002016e8:	fe043703          	ld	a4,-32(s0)
ffffffe0002016ec:	00e7b023          	sd	a4,0(a5)
ffffffe0002016f0:	0340006f          	j	ffffffe000201724 <do_mmap+0xe4>
    } else {
        while (current->vm_next) {
            current = current->vm_next;
ffffffe0002016f4:	fe843783          	ld	a5,-24(s0)
ffffffe0002016f8:	0187b783          	ld	a5,24(a5)
ffffffe0002016fc:	fef43423          	sd	a5,-24(s0)
        while (current->vm_next) {
ffffffe000201700:	fe843783          	ld	a5,-24(s0)
ffffffe000201704:	0187b783          	ld	a5,24(a5)
ffffffe000201708:	fe0796e3          	bnez	a5,ffffffe0002016f4 <do_mmap+0xb4>
        }
        current->vm_next = vma;
ffffffe00020170c:	fe843783          	ld	a5,-24(s0)
ffffffe000201710:	fe043703          	ld	a4,-32(s0)
ffffffe000201714:	00e7bc23          	sd	a4,24(a5)
        vma->vm_prev = current;
ffffffe000201718:	fe043783          	ld	a5,-32(s0)
ffffffe00020171c:	fe843703          	ld	a4,-24(s0)
ffffffe000201720:	02e7b023          	sd	a4,32(a5)
    }
    return addr;
ffffffe000201724:	fd043783          	ld	a5,-48(s0)
ffffffe000201728:	00078513          	mv	a0,a5
ffffffe00020172c:	04813083          	ld	ra,72(sp)
ffffffe000201730:	04013403          	ld	s0,64(sp)
ffffffe000201734:	05010113          	addi	sp,sp,80
ffffffe000201738:	00008067          	ret

ffffffe00020173c <sbi_ecall>:
#include "sbi.h"
#include "printk.h"

struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
ffffffe00020173c:	f9010113          	addi	sp,sp,-112
ffffffe000201740:	06813423          	sd	s0,104(sp)
ffffffe000201744:	07010413          	addi	s0,sp,112
ffffffe000201748:	fca43423          	sd	a0,-56(s0)
ffffffe00020174c:	fcb43023          	sd	a1,-64(s0)
ffffffe000201750:	fac43c23          	sd	a2,-72(s0)
ffffffe000201754:	fad43823          	sd	a3,-80(s0)
ffffffe000201758:	fae43423          	sd	a4,-88(s0)
ffffffe00020175c:	faf43023          	sd	a5,-96(s0)
ffffffe000201760:	f9043c23          	sd	a6,-104(s0)
ffffffe000201764:	f9143823          	sd	a7,-112(s0)
    struct sbiret return_val;
    __asm__ volatile (
ffffffe000201768:	fc843783          	ld	a5,-56(s0)
ffffffe00020176c:	fc043703          	ld	a4,-64(s0)
ffffffe000201770:	fb843683          	ld	a3,-72(s0)
ffffffe000201774:	fb043603          	ld	a2,-80(s0)
ffffffe000201778:	fa843583          	ld	a1,-88(s0)
ffffffe00020177c:	fa043503          	ld	a0,-96(s0)
ffffffe000201780:	f9843803          	ld	a6,-104(s0)
ffffffe000201784:	f9043883          	ld	a7,-112(s0)
ffffffe000201788:	00078893          	mv	a7,a5
ffffffe00020178c:	00070813          	mv	a6,a4
ffffffe000201790:	00068513          	mv	a0,a3
ffffffe000201794:	00060593          	mv	a1,a2
ffffffe000201798:	00058613          	mv	a2,a1
ffffffe00020179c:	00050693          	mv	a3,a0
ffffffe0002017a0:	00080713          	mv	a4,a6
ffffffe0002017a4:	00088793          	mv	a5,a7
ffffffe0002017a8:	00000073          	ecall
ffffffe0002017ac:	00050713          	mv	a4,a0
ffffffe0002017b0:	00058793          	mv	a5,a1
ffffffe0002017b4:	fce43823          	sd	a4,-48(s0)
ffffffe0002017b8:	fcf43c23          	sd	a5,-40(s0)
            : [in_eid] "r" (eid), [in_fid] "r" (fid), [in_arg0] "r" (arg0),
            [in_arg1] "r" (arg1), [in_arg2] "r" (arg2), [in_arg3] "r" (arg3),
            [in_arg4] "r" (arg4), [in_arg5] "r" (arg5)
            : "memory"
    );
    return return_val;
ffffffe0002017bc:	fd043783          	ld	a5,-48(s0)
ffffffe0002017c0:	fef43023          	sd	a5,-32(s0)
ffffffe0002017c4:	fd843783          	ld	a5,-40(s0)
ffffffe0002017c8:	fef43423          	sd	a5,-24(s0)
ffffffe0002017cc:	fe043703          	ld	a4,-32(s0)
ffffffe0002017d0:	fe843783          	ld	a5,-24(s0)
ffffffe0002017d4:	00070313          	mv	t1,a4
ffffffe0002017d8:	00078393          	mv	t2,a5
ffffffe0002017dc:	00030713          	mv	a4,t1
ffffffe0002017e0:	00038793          	mv	a5,t2
}
ffffffe0002017e4:	00070513          	mv	a0,a4
ffffffe0002017e8:	00078593          	mv	a1,a5
ffffffe0002017ec:	06813403          	ld	s0,104(sp)
ffffffe0002017f0:	07010113          	addi	sp,sp,112
ffffffe0002017f4:	00008067          	ret

ffffffe0002017f8 <sbi_debug_console_write_byte>:

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
ffffffe0002017f8:	fc010113          	addi	sp,sp,-64
ffffffe0002017fc:	02813c23          	sd	s0,56(sp)
ffffffe000201800:	04010413          	addi	s0,sp,64
ffffffe000201804:	00050793          	mv	a5,a0
ffffffe000201808:	fcf407a3          	sb	a5,-49(s0)
    struct sbiret return_val;
    __asm__ volatile(
ffffffe00020180c:	fcf44783          	lbu	a5,-49(s0)
ffffffe000201810:	444248b7          	lui	a7,0x44424
ffffffe000201814:	34e8889b          	addiw	a7,a7,846 # 4442434e <PHY_SIZE+0x3c42434e>
ffffffe000201818:	00200813          	li	a6,2
ffffffe00020181c:	00078513          	mv	a0,a5
ffffffe000201820:	00000073          	ecall
ffffffe000201824:	00050713          	mv	a4,a0
ffffffe000201828:	00058793          	mv	a5,a1
ffffffe00020182c:	fce43823          	sd	a4,-48(s0)
ffffffe000201830:	fcf43c23          	sd	a5,-40(s0)
            "mv %[out_value], a1"
            : [out_error] "=r" (return_val.error), [out_value] "=r" (return_val.value)
            : [byte] "r" (byte)
            : "memory"
            );
    return return_val;
ffffffe000201834:	fd043783          	ld	a5,-48(s0)
ffffffe000201838:	fef43023          	sd	a5,-32(s0)
ffffffe00020183c:	fd843783          	ld	a5,-40(s0)
ffffffe000201840:	fef43423          	sd	a5,-24(s0)
ffffffe000201844:	fe043703          	ld	a4,-32(s0)
ffffffe000201848:	fe843783          	ld	a5,-24(s0)
ffffffe00020184c:	00070613          	mv	a2,a4
ffffffe000201850:	00078693          	mv	a3,a5
ffffffe000201854:	00060713          	mv	a4,a2
ffffffe000201858:	00068793          	mv	a5,a3
}
ffffffe00020185c:	00070513          	mv	a0,a4
ffffffe000201860:	00078593          	mv	a1,a5
ffffffe000201864:	03813403          	ld	s0,56(sp)
ffffffe000201868:	04010113          	addi	sp,sp,64
ffffffe00020186c:	00008067          	ret

ffffffe000201870 <sbi_system_reset>:

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
ffffffe000201870:	fc010113          	addi	sp,sp,-64
ffffffe000201874:	02813c23          	sd	s0,56(sp)
ffffffe000201878:	04010413          	addi	s0,sp,64
ffffffe00020187c:	00050793          	mv	a5,a0
ffffffe000201880:	00058713          	mv	a4,a1
ffffffe000201884:	fcf42623          	sw	a5,-52(s0)
ffffffe000201888:	00070793          	mv	a5,a4
ffffffe00020188c:	fcf42423          	sw	a5,-56(s0)
    struct sbiret return_val;
    __asm__ volatile(
ffffffe000201890:	fcc42783          	lw	a5,-52(s0)
ffffffe000201894:	fc842703          	lw	a4,-56(s0)
ffffffe000201898:	535258b7          	lui	a7,0x53525
ffffffe00020189c:	3548889b          	addiw	a7,a7,852 # 53525354 <PHY_SIZE+0x4b525354>
ffffffe0002018a0:	00000813          	li	a6,0
ffffffe0002018a4:	00078513          	mv	a0,a5
ffffffe0002018a8:	00070593          	mv	a1,a4
ffffffe0002018ac:	00000073          	ecall
ffffffe0002018b0:	00050713          	mv	a4,a0
ffffffe0002018b4:	00058793          	mv	a5,a1
ffffffe0002018b8:	fce43823          	sd	a4,-48(s0)
ffffffe0002018bc:	fcf43c23          	sd	a5,-40(s0)
            "mv %[out_value], a1\n"
            : [out_error] "=r" (return_val.error), [out_value] "=r" (return_val.value)
            : [reset_type] "r" (reset_type), [reset_reason] "r" (reset_reason)
            : "memory"
            );
    return return_val;
ffffffe0002018c0:	fd043783          	ld	a5,-48(s0)
ffffffe0002018c4:	fef43023          	sd	a5,-32(s0)
ffffffe0002018c8:	fd843783          	ld	a5,-40(s0)
ffffffe0002018cc:	fef43423          	sd	a5,-24(s0)
ffffffe0002018d0:	fe043703          	ld	a4,-32(s0)
ffffffe0002018d4:	fe843783          	ld	a5,-24(s0)
ffffffe0002018d8:	00070613          	mv	a2,a4
ffffffe0002018dc:	00078693          	mv	a3,a5
ffffffe0002018e0:	00060713          	mv	a4,a2
ffffffe0002018e4:	00068793          	mv	a5,a3
}
ffffffe0002018e8:	00070513          	mv	a0,a4
ffffffe0002018ec:	00078593          	mv	a1,a5
ffffffe0002018f0:	03813403          	ld	s0,56(sp)
ffffffe0002018f4:	04010113          	addi	sp,sp,64
ffffffe0002018f8:	00008067          	ret

ffffffe0002018fc <sbi_set_timer>:

struct sbiret sbi_set_timer(uint64_t stime_value){
ffffffe0002018fc:	fc010113          	addi	sp,sp,-64
ffffffe000201900:	02813c23          	sd	s0,56(sp)
ffffffe000201904:	04010413          	addi	s0,sp,64
ffffffe000201908:	fca43423          	sd	a0,-56(s0)
    struct sbiret return_val;
    // printk("enter sbi_set_timer\n");
    __asm__ volatile(
ffffffe00020190c:	fc843783          	ld	a5,-56(s0)
ffffffe000201910:	544958b7          	lui	a7,0x54495
ffffffe000201914:	d458889b          	addiw	a7,a7,-699 # 54494d45 <PHY_SIZE+0x4c494d45>
ffffffe000201918:	00000813          	li	a6,0
ffffffe00020191c:	00078513          	mv	a0,a5
ffffffe000201920:	00000073          	ecall
ffffffe000201924:	00050713          	mv	a4,a0
ffffffe000201928:	00058793          	mv	a5,a1
ffffffe00020192c:	fce43823          	sd	a4,-48(s0)
ffffffe000201930:	fcf43c23          	sd	a5,-40(s0)
            "mv %[out_value], a1\n"
            : [out_error] "=r" (return_val.error), [out_value] "=r" (return_val.value)
            : [stime] "r" (stime_value)
            : "memory"
            );
    return return_val;
ffffffe000201934:	fd043783          	ld	a5,-48(s0)
ffffffe000201938:	fef43023          	sd	a5,-32(s0)
ffffffe00020193c:	fd843783          	ld	a5,-40(s0)
ffffffe000201940:	fef43423          	sd	a5,-24(s0)
ffffffe000201944:	fe043703          	ld	a4,-32(s0)
ffffffe000201948:	fe843783          	ld	a5,-24(s0)
ffffffe00020194c:	00070613          	mv	a2,a4
ffffffe000201950:	00078693          	mv	a3,a5
ffffffe000201954:	00060713          	mv	a4,a2
ffffffe000201958:	00068793          	mv	a5,a3
}
ffffffe00020195c:	00070513          	mv	a0,a4
ffffffe000201960:	00078593          	mv	a1,a5
ffffffe000201964:	03813403          	ld	s0,56(sp)
ffffffe000201968:	04010113          	addi	sp,sp,64
ffffffe00020196c:	00008067          	ret

ffffffe000201970 <sbi_debug_console_write>:

struct sbiret sbi_debug_console_write(unsigned long num_bytes, unsigned long base_addr_lo, unsigned long base_addr_hi){
ffffffe000201970:	fb010113          	addi	sp,sp,-80
ffffffe000201974:	04813423          	sd	s0,72(sp)
ffffffe000201978:	05010413          	addi	s0,sp,80
ffffffe00020197c:	fca43423          	sd	a0,-56(s0)
ffffffe000201980:	fcb43023          	sd	a1,-64(s0)
ffffffe000201984:	fac43c23          	sd	a2,-72(s0)
    struct sbiret return_val;
    __asm__ volatile(
ffffffe000201988:	fc843783          	ld	a5,-56(s0)
ffffffe00020198c:	fc043703          	ld	a4,-64(s0)
ffffffe000201990:	fb843683          	ld	a3,-72(s0)
ffffffe000201994:	444248b7          	lui	a7,0x44424
ffffffe000201998:	34e8889b          	addiw	a7,a7,846 # 4442434e <PHY_SIZE+0x3c42434e>
ffffffe00020199c:	00000813          	li	a6,0
ffffffe0002019a0:	00078513          	mv	a0,a5
ffffffe0002019a4:	00070593          	mv	a1,a4
ffffffe0002019a8:	00068613          	mv	a2,a3
ffffffe0002019ac:	00000073          	ecall
ffffffe0002019b0:	00050713          	mv	a4,a0
ffffffe0002019b4:	00058793          	mv	a5,a1
ffffffe0002019b8:	fce43823          	sd	a4,-48(s0)
ffffffe0002019bc:	fcf43c23          	sd	a5,-40(s0)
            "mv %[out_value], a1\n"
            : [out_error] "=r" (return_val.error), [out_value] "=r" (return_val.value)
            : [num_bytes] "r" (num_bytes), [addr_lo] "r" (base_addr_lo), [addr_hi] "r" (base_addr_hi)
            : "memory"
            );
    return return_val;
ffffffe0002019c0:	fd043783          	ld	a5,-48(s0)
ffffffe0002019c4:	fef43023          	sd	a5,-32(s0)
ffffffe0002019c8:	fd843783          	ld	a5,-40(s0)
ffffffe0002019cc:	fef43423          	sd	a5,-24(s0)
ffffffe0002019d0:	fe043703          	ld	a4,-32(s0)
ffffffe0002019d4:	fe843783          	ld	a5,-24(s0)
ffffffe0002019d8:	00070813          	mv	a6,a4
ffffffe0002019dc:	00078893          	mv	a7,a5
ffffffe0002019e0:	00080713          	mv	a4,a6
ffffffe0002019e4:	00088793          	mv	a5,a7
}
ffffffe0002019e8:	00070513          	mv	a0,a4
ffffffe0002019ec:	00078593          	mv	a1,a5
ffffffe0002019f0:	04813403          	ld	s0,72(sp)
ffffffe0002019f4:	05010113          	addi	sp,sp,80
ffffffe0002019f8:	00008067          	ret

ffffffe0002019fc <sbi_debug_console_read>:

struct sbiret sbi_debug_console_read(unsigned long num_bytes, unsigned long base_addr_lo, unsigned long base_addr_hi){
ffffffe0002019fc:	fb010113          	addi	sp,sp,-80
ffffffe000201a00:	04813423          	sd	s0,72(sp)
ffffffe000201a04:	05010413          	addi	s0,sp,80
ffffffe000201a08:	fca43423          	sd	a0,-56(s0)
ffffffe000201a0c:	fcb43023          	sd	a1,-64(s0)
ffffffe000201a10:	fac43c23          	sd	a2,-72(s0)
    struct sbiret return_val;
    __asm__ volatile(
ffffffe000201a14:	fc843783          	ld	a5,-56(s0)
ffffffe000201a18:	fc043703          	ld	a4,-64(s0)
ffffffe000201a1c:	fb843683          	ld	a3,-72(s0)
ffffffe000201a20:	444248b7          	lui	a7,0x44424
ffffffe000201a24:	34e8889b          	addiw	a7,a7,846 # 4442434e <PHY_SIZE+0x3c42434e>
ffffffe000201a28:	00100813          	li	a6,1
ffffffe000201a2c:	00078513          	mv	a0,a5
ffffffe000201a30:	00070593          	mv	a1,a4
ffffffe000201a34:	00068613          	mv	a2,a3
ffffffe000201a38:	00000073          	ecall
ffffffe000201a3c:	00050713          	mv	a4,a0
ffffffe000201a40:	00058793          	mv	a5,a1
ffffffe000201a44:	fce43823          	sd	a4,-48(s0)
ffffffe000201a48:	fcf43c23          	sd	a5,-40(s0)
            "mv %[out_value], a1\n"
            : [out_error] "=r" (return_val.error), [out_value] "=r" (return_val.value)
    : [num_bytes] "r" (num_bytes), [addr_lo] "r" (base_addr_lo), [addr_hi] "r" (base_addr_hi)
    : "memory"
    );
    return return_val;
ffffffe000201a4c:	fd043783          	ld	a5,-48(s0)
ffffffe000201a50:	fef43023          	sd	a5,-32(s0)
ffffffe000201a54:	fd843783          	ld	a5,-40(s0)
ffffffe000201a58:	fef43423          	sd	a5,-24(s0)
ffffffe000201a5c:	fe043703          	ld	a4,-32(s0)
ffffffe000201a60:	fe843783          	ld	a5,-24(s0)
ffffffe000201a64:	00070813          	mv	a6,a4
ffffffe000201a68:	00078893          	mv	a7,a5
ffffffe000201a6c:	00080713          	mv	a4,a6
ffffffe000201a70:	00088793          	mv	a5,a7
ffffffe000201a74:	00070513          	mv	a0,a4
ffffffe000201a78:	00078593          	mv	a1,a5
ffffffe000201a7c:	04813403          	ld	s0,72(sp)
ffffffe000201a80:	05010113          	addi	sp,sp,80
ffffffe000201a84:	00008067          	ret

ffffffe000201a88 <output_string>:
struct pt_regs {
    uint64_t gpr[32];   // 通用寄存器 x0 ~ x31
    uint64_t sepc;      // 异常发生时的返回地址
};

void output_string(const char *str) {
ffffffe000201a88:	fc010113          	addi	sp,sp,-64
ffffffe000201a8c:	02113c23          	sd	ra,56(sp)
ffffffe000201a90:	02813823          	sd	s0,48(sp)
ffffffe000201a94:	04010413          	addi	s0,sp,64
ffffffe000201a98:	fca43423          	sd	a0,-56(s0)
    uint64_t base_addr_lo = (uint64_t)(uintptr_t)str;
ffffffe000201a9c:	fc843783          	ld	a5,-56(s0)
ffffffe000201aa0:	fef43023          	sd	a5,-32(s0)
    uint64_t base_addr_hi = (uintptr_t)(str)>>32;
ffffffe000201aa4:	fc843783          	ld	a5,-56(s0)
ffffffe000201aa8:	0207d793          	srli	a5,a5,0x20
ffffffe000201aac:	fcf43c23          	sd	a5,-40(s0)
    // 计算字符串的长度
    int length = 0;
ffffffe000201ab0:	fe042623          	sw	zero,-20(s0)
    const char *p = str;
ffffffe000201ab4:	fc843783          	ld	a5,-56(s0)
ffffffe000201ab8:	fcf43823          	sd	a5,-48(s0)
    while (p[length] != '\0') {
ffffffe000201abc:	0100006f          	j	ffffffe000201acc <output_string+0x44>
        length++;
ffffffe000201ac0:	fec42783          	lw	a5,-20(s0)
ffffffe000201ac4:	0017879b          	addiw	a5,a5,1
ffffffe000201ac8:	fef42623          	sw	a5,-20(s0)
    while (p[length] != '\0') {
ffffffe000201acc:	fec42783          	lw	a5,-20(s0)
ffffffe000201ad0:	fd043703          	ld	a4,-48(s0)
ffffffe000201ad4:	00f707b3          	add	a5,a4,a5
ffffffe000201ad8:	0007c783          	lbu	a5,0(a5)
ffffffe000201adc:	fe0792e3          	bnez	a5,ffffffe000201ac0 <output_string+0x38>
    }
    sbi_debug_console_write(length, base_addr_lo, base_addr_hi);
ffffffe000201ae0:	fec42783          	lw	a5,-20(s0)
ffffffe000201ae4:	fd843603          	ld	a2,-40(s0)
ffffffe000201ae8:	fe043583          	ld	a1,-32(s0)
ffffffe000201aec:	00078513          	mv	a0,a5
ffffffe000201af0:	e81ff0ef          	jal	ffffffe000201970 <sbi_debug_console_write>
}
ffffffe000201af4:	00000013          	nop
ffffffe000201af8:	03813083          	ld	ra,56(sp)
ffffffe000201afc:	03013403          	ld	s0,48(sp)
ffffffe000201b00:	04010113          	addi	sp,sp,64
ffffffe000201b04:	00008067          	ret

ffffffe000201b08 <trap_handler>:

void trap_handler(uint64_t scause, uint64_t sepc, struct pt_regs *regs) {
ffffffe000201b08:	f9010113          	addi	sp,sp,-112
ffffffe000201b0c:	06113423          	sd	ra,104(sp)
ffffffe000201b10:	06813023          	sd	s0,96(sp)
ffffffe000201b14:	07010413          	addi	s0,sp,112
ffffffe000201b18:	faa43423          	sd	a0,-88(s0)
ffffffe000201b1c:	fab43023          	sd	a1,-96(s0)
ffffffe000201b20:	f8c43c23          	sd	a2,-104(s0)
    // 通过 `scause` 判断 trap 类型
    uint64_t highest_bit = 0x8000000000000000;
ffffffe000201b24:	fff00793          	li	a5,-1
ffffffe000201b28:	03f79793          	slli	a5,a5,0x3f
ffffffe000201b2c:	fef43423          	sd	a5,-24(s0)
    int is_interrupt = scause & highest_bit;
ffffffe000201b30:	fa843783          	ld	a5,-88(s0)
ffffffe000201b34:	0007871b          	sext.w	a4,a5
ffffffe000201b38:	fe843783          	ld	a5,-24(s0)
ffffffe000201b3c:	0007879b          	sext.w	a5,a5
ffffffe000201b40:	00f777b3          	and	a5,a4,a5
ffffffe000201b44:	0007879b          	sext.w	a5,a5
ffffffe000201b48:	fef42223          	sw	a5,-28(s0)
    uint64_t rest_bit = scause - highest_bit;
ffffffe000201b4c:	fa843703          	ld	a4,-88(s0)
ffffffe000201b50:	fe843783          	ld	a5,-24(s0)
ffffffe000201b54:	40f707b3          	sub	a5,a4,a5
ffffffe000201b58:	fcf43c23          	sd	a5,-40(s0)
    if (is_interrupt) {
ffffffe000201b5c:	fe442783          	lw	a5,-28(s0)
ffffffe000201b60:	0007879b          	sext.w	a5,a5
ffffffe000201b64:	04078663          	beqz	a5,ffffffe000201bb0 <trap_handler+0xa8>
        if (rest_bit == 5){
ffffffe000201b68:	fd843703          	ld	a4,-40(s0)
ffffffe000201b6c:	00500793          	li	a5,5
ffffffe000201b70:	00f71863          	bne	a4,a5,ffffffe000201b80 <trap_handler+0x78>
             // output_string("[S] Supervisor Mode Timer Interrupt\n");
            clock_set_next_event();
ffffffe000201b74:	f54fe0ef          	jal	ffffffe0002002c8 <clock_set_next_event>
            do_timer();
ffffffe000201b78:	fd4ff0ef          	jal	ffffffe00020134c <do_timer>
    // 如果是 interrupt 判断是否是 timer interrupt
    // 如果是 timer interrupt 则打印输出相关信息，并通过 `clock_set_next_event()` 设置下一次时钟中断
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试

}
ffffffe000201b7c:	10c0006f          	j	ffffffe000201c88 <trap_handler+0x180>
            Err("Unhandled Interrupt: scause=%d, sepc=0x%x\n", scause,sepc );
ffffffe000201b80:	fa043783          	ld	a5,-96(s0)
ffffffe000201b84:	fa843703          	ld	a4,-88(s0)
ffffffe000201b88:	00002697          	auipc	a3,0x2
ffffffe000201b8c:	7d868693          	addi	a3,a3,2008 # ffffffe000204360 <__func__.1>
ffffffe000201b90:	02900613          	li	a2,41
ffffffe000201b94:	00002597          	auipc	a1,0x2
ffffffe000201b98:	56458593          	addi	a1,a1,1380 # ffffffe0002040f8 <_srodata+0xf8>
ffffffe000201b9c:	00002517          	auipc	a0,0x2
ffffffe000201ba0:	56450513          	addi	a0,a0,1380 # ffffffe000204100 <_srodata+0x100>
ffffffe000201ba4:	179010ef          	jal	ffffffe00020351c <printk>
ffffffe000201ba8:	00000013          	nop
ffffffe000201bac:	ffdff06f          	j	ffffffe000201ba8 <trap_handler+0xa0>
    } else if (scause == 8) { // Environment call from U-mode
ffffffe000201bb0:	fa843703          	ld	a4,-88(s0)
ffffffe000201bb4:	00800793          	li	a5,8
ffffffe000201bb8:	00f71863          	bne	a4,a5,ffffffe000201bc8 <trap_handler+0xc0>
        syscall(regs);
ffffffe000201bbc:	f9843503          	ld	a0,-104(s0)
ffffffe000201bc0:	0d8000ef          	jal	ffffffe000201c98 <syscall>
}
ffffffe000201bc4:	0c40006f          	j	ffffffe000201c88 <trap_handler+0x180>
    } else if (scause == 12 || scause == 13 || scause == 15){
ffffffe000201bc8:	fa843703          	ld	a4,-88(s0)
ffffffe000201bcc:	00c00793          	li	a5,12
ffffffe000201bd0:	00f70e63          	beq	a4,a5,ffffffe000201bec <trap_handler+0xe4>
ffffffe000201bd4:	fa843703          	ld	a4,-88(s0)
ffffffe000201bd8:	00d00793          	li	a5,13
ffffffe000201bdc:	00f70863          	beq	a4,a5,ffffffe000201bec <trap_handler+0xe4>
ffffffe000201be0:	fa843703          	ld	a4,-88(s0)
ffffffe000201be4:	00f00793          	li	a5,15
ffffffe000201be8:	06f71863          	bne	a4,a5,ffffffe000201c58 <trap_handler+0x150>
        uint64_t stval = csr_read(stval);
ffffffe000201bec:	143027f3          	csrr	a5,stval
ffffffe000201bf0:	fcf43823          	sd	a5,-48(s0)
ffffffe000201bf4:	fd043783          	ld	a5,-48(s0)
ffffffe000201bf8:	fcf43423          	sd	a5,-56(s0)
        uint64_t sepc = csr_read(sepc);
ffffffe000201bfc:	141027f3          	csrr	a5,sepc
ffffffe000201c00:	fcf43023          	sd	a5,-64(s0)
ffffffe000201c04:	fc043783          	ld	a5,-64(s0)
ffffffe000201c08:	faf43c23          	sd	a5,-72(s0)
        Info("[PID=%d, PC=0x%x] valid page fault at [0x%x] with scause %d", current->pid, sepc, stval, scause);
ffffffe000201c0c:	00007797          	auipc	a5,0x7
ffffffe000201c10:	40478793          	addi	a5,a5,1028 # ffffffe000209010 <current>
ffffffe000201c14:	0007b783          	ld	a5,0(a5)
ffffffe000201c18:	0187b703          	ld	a4,24(a5)
ffffffe000201c1c:	fa843883          	ld	a7,-88(s0)
ffffffe000201c20:	fc843803          	ld	a6,-56(s0)
ffffffe000201c24:	fb843783          	ld	a5,-72(s0)
ffffffe000201c28:	00002697          	auipc	a3,0x2
ffffffe000201c2c:	73868693          	addi	a3,a3,1848 # ffffffe000204360 <__func__.1>
ffffffe000201c30:	03000613          	li	a2,48
ffffffe000201c34:	00002597          	auipc	a1,0x2
ffffffe000201c38:	4c458593          	addi	a1,a1,1220 # ffffffe0002040f8 <_srodata+0xf8>
ffffffe000201c3c:	00002517          	auipc	a0,0x2
ffffffe000201c40:	50c50513          	addi	a0,a0,1292 # ffffffe000204148 <_srodata+0x148>
ffffffe000201c44:	0d9010ef          	jal	ffffffe00020351c <printk>
        do_page_fault(regs);
ffffffe000201c48:	f9843503          	ld	a0,-104(s0)
ffffffe000201c4c:	194000ef          	jal	ffffffe000201de0 <do_page_fault>
    } else if (scause == 12 || scause == 13 || scause == 15){
ffffffe000201c50:	00000013          	nop
}
ffffffe000201c54:	0340006f          	j	ffffffe000201c88 <trap_handler+0x180>
        Err("Unhandled Exception: scause=%d, sepc=0x%x\n", scause, sepc);
ffffffe000201c58:	fa043783          	ld	a5,-96(s0)
ffffffe000201c5c:	fa843703          	ld	a4,-88(s0)
ffffffe000201c60:	00002697          	auipc	a3,0x2
ffffffe000201c64:	70068693          	addi	a3,a3,1792 # ffffffe000204360 <__func__.1>
ffffffe000201c68:	03300613          	li	a2,51
ffffffe000201c6c:	00002597          	auipc	a1,0x2
ffffffe000201c70:	48c58593          	addi	a1,a1,1164 # ffffffe0002040f8 <_srodata+0xf8>
ffffffe000201c74:	00002517          	auipc	a0,0x2
ffffffe000201c78:	52c50513          	addi	a0,a0,1324 # ffffffe0002041a0 <_srodata+0x1a0>
ffffffe000201c7c:	0a1010ef          	jal	ffffffe00020351c <printk>
ffffffe000201c80:	00000013          	nop
ffffffe000201c84:	ffdff06f          	j	ffffffe000201c80 <trap_handler+0x178>
}
ffffffe000201c88:	06813083          	ld	ra,104(sp)
ffffffe000201c8c:	06013403          	ld	s0,96(sp)
ffffffe000201c90:	07010113          	addi	sp,sp,112
ffffffe000201c94:	00008067          	ret

ffffffe000201c98 <syscall>:

void syscall(struct pt_regs *regs){
ffffffe000201c98:	fa010113          	addi	sp,sp,-96
ffffffe000201c9c:	04113c23          	sd	ra,88(sp)
ffffffe000201ca0:	04813823          	sd	s0,80(sp)
ffffffe000201ca4:	06010413          	addi	s0,sp,96
ffffffe000201ca8:	faa43423          	sd	a0,-88(s0)
    uint64_t syscall_num = regs->gpr[17]; // a7
ffffffe000201cac:	fa843783          	ld	a5,-88(s0)
ffffffe000201cb0:	0887b783          	ld	a5,136(a5)
ffffffe000201cb4:	fef43023          	sd	a5,-32(s0)
    uint64_t arg0 = regs->gpr[10];        // a0
ffffffe000201cb8:	fa843783          	ld	a5,-88(s0)
ffffffe000201cbc:	0507b783          	ld	a5,80(a5)
ffffffe000201cc0:	fcf43c23          	sd	a5,-40(s0)
    uint64_t arg1 = regs->gpr[11];        // a1
ffffffe000201cc4:	fa843783          	ld	a5,-88(s0)
ffffffe000201cc8:	0587b783          	ld	a5,88(a5)
ffffffe000201ccc:	fcf43823          	sd	a5,-48(s0)
    uint64_t arg2 = regs->gpr[12];        // a2
ffffffe000201cd0:	fa843783          	ld	a5,-88(s0)
ffffffe000201cd4:	0607b783          	ld	a5,96(a5)
ffffffe000201cd8:	fcf43423          	sd	a5,-56(s0)
    // printk("syscall number = %llx\n", syscall_num);
    switch (syscall_num) {
ffffffe000201cdc:	fe043703          	ld	a4,-32(s0)
ffffffe000201ce0:	04000793          	li	a5,64
ffffffe000201ce4:	00f70a63          	beq	a4,a5,ffffffe000201cf8 <syscall+0x60>
ffffffe000201ce8:	fe043703          	ld	a4,-32(s0)
ffffffe000201cec:	0ac00793          	li	a5,172
ffffffe000201cf0:	08f70663          	beq	a4,a5,ffffffe000201d7c <syscall+0xe4>
ffffffe000201cf4:	0a40006f          	j	ffffffe000201d98 <syscall+0x100>
        case SYS_WRITE:
            if (arg0 == 1){
ffffffe000201cf8:	fd843703          	ld	a4,-40(s0)
ffffffe000201cfc:	00100793          	li	a5,1
ffffffe000201d00:	06f71063          	bne	a4,a5,ffffffe000201d60 <syscall+0xc8>
                char* buf = (char* )(arg1);
ffffffe000201d04:	fd043783          	ld	a5,-48(s0)
ffffffe000201d08:	fcf43023          	sd	a5,-64(s0)
                for (uint64_t i = 0; i < arg2; i++) {
ffffffe000201d0c:	fe043423          	sd	zero,-24(s0)
ffffffe000201d10:	0340006f          	j	ffffffe000201d44 <syscall+0xac>
                    printk("%c", buf[i]);
ffffffe000201d14:	fc043703          	ld	a4,-64(s0)
ffffffe000201d18:	fe843783          	ld	a5,-24(s0)
ffffffe000201d1c:	00f707b3          	add	a5,a4,a5
ffffffe000201d20:	0007c783          	lbu	a5,0(a5)
ffffffe000201d24:	0007879b          	sext.w	a5,a5
ffffffe000201d28:	00078593          	mv	a1,a5
ffffffe000201d2c:	00002517          	auipc	a0,0x2
ffffffe000201d30:	4bc50513          	addi	a0,a0,1212 # ffffffe0002041e8 <_srodata+0x1e8>
ffffffe000201d34:	7e8010ef          	jal	ffffffe00020351c <printk>
                for (uint64_t i = 0; i < arg2; i++) {
ffffffe000201d38:	fe843783          	ld	a5,-24(s0)
ffffffe000201d3c:	00178793          	addi	a5,a5,1
ffffffe000201d40:	fef43423          	sd	a5,-24(s0)
ffffffe000201d44:	fe843703          	ld	a4,-24(s0)
ffffffe000201d48:	fc843783          	ld	a5,-56(s0)
ffffffe000201d4c:	fcf764e3          	bltu	a4,a5,ffffffe000201d14 <syscall+0x7c>
                }
                regs->gpr[10] = arg2;
ffffffe000201d50:	fa843783          	ld	a5,-88(s0)
ffffffe000201d54:	fc843703          	ld	a4,-56(s0)
ffffffe000201d58:	04e7b823          	sd	a4,80(a5)
            } else {
                printk("Can't call syscall write.\n");
                regs->gpr[10] = -1;
            }
            break;
ffffffe000201d5c:	04c0006f          	j	ffffffe000201da8 <syscall+0x110>
                printk("Can't call syscall write.\n");
ffffffe000201d60:	00002517          	auipc	a0,0x2
ffffffe000201d64:	49050513          	addi	a0,a0,1168 # ffffffe0002041f0 <_srodata+0x1f0>
ffffffe000201d68:	7b4010ef          	jal	ffffffe00020351c <printk>
                regs->gpr[10] = -1;
ffffffe000201d6c:	fa843783          	ld	a5,-88(s0)
ffffffe000201d70:	fff00713          	li	a4,-1
ffffffe000201d74:	04e7b823          	sd	a4,80(a5)
            break;
ffffffe000201d78:	0300006f          	j	ffffffe000201da8 <syscall+0x110>
        case SYS_GETPID:
            regs->gpr[10] = current->pid;
ffffffe000201d7c:	00007797          	auipc	a5,0x7
ffffffe000201d80:	29478793          	addi	a5,a5,660 # ffffffe000209010 <current>
ffffffe000201d84:	0007b783          	ld	a5,0(a5)
ffffffe000201d88:	0187b703          	ld	a4,24(a5)
ffffffe000201d8c:	fa843783          	ld	a5,-88(s0)
ffffffe000201d90:	04e7b823          	sd	a4,80(a5)
            break;
ffffffe000201d94:	0140006f          	j	ffffffe000201da8 <syscall+0x110>
        default:
            regs->gpr[10] = -1; // 默认返回值为-1
ffffffe000201d98:	fa843783          	ld	a5,-88(s0)
ffffffe000201d9c:	fff00713          	li	a4,-1
ffffffe000201da0:	04e7b823          	sd	a4,80(a5)
            break;
ffffffe000201da4:	00000013          	nop
    }
    regs->sepc += 4;
ffffffe000201da8:	fa843783          	ld	a5,-88(s0)
ffffffe000201dac:	1007b783          	ld	a5,256(a5)
ffffffe000201db0:	00478713          	addi	a4,a5,4
ffffffe000201db4:	fa843783          	ld	a5,-88(s0)
ffffffe000201db8:	10e7b023          	sd	a4,256(a5)
    uint64_t sepc = csr_read(sepc);
ffffffe000201dbc:	141027f3          	csrr	a5,sepc
ffffffe000201dc0:	faf43c23          	sd	a5,-72(s0)
ffffffe000201dc4:	fb843783          	ld	a5,-72(s0)
ffffffe000201dc8:	faf43823          	sd	a5,-80(s0)
    // 不知道是否需要，先留着
//    sepc += 4;
//    csr_write(sepc, sepc);
}
ffffffe000201dcc:	00000013          	nop
ffffffe000201dd0:	05813083          	ld	ra,88(sp)
ffffffe000201dd4:	05013403          	ld	s0,80(sp)
ffffffe000201dd8:	06010113          	addi	sp,sp,96
ffffffe000201ddc:	00008067          	ret

ffffffe000201de0 <do_page_fault>:

/* 实现page-fault handler */
void do_page_fault(struct pt_regs *regs) {
ffffffe000201de0:	f8010113          	addi	sp,sp,-128
ffffffe000201de4:	06113c23          	sd	ra,120(sp)
ffffffe000201de8:	06813823          	sd	s0,112(sp)
ffffffe000201dec:	08010413          	addi	s0,sp,128
ffffffe000201df0:	f8a43423          	sd	a0,-120(s0)
//    Err("Function not implemented. \n");
    // uint64_t bad_addr = regs->stval;  //获得访问出错的虚拟内存地址
    uint64_t bad_addr = csr_read(stval);
ffffffe000201df4:	143027f3          	csrr	a5,stval
ffffffe000201df8:	fef43423          	sd	a5,-24(s0)
ffffffe000201dfc:	fe843783          	ld	a5,-24(s0)
ffffffe000201e00:	fef43023          	sd	a5,-32(s0)
    uint64_t scause = csr_read(scause);
ffffffe000201e04:	142027f3          	csrr	a5,scause
ffffffe000201e08:	fcf43c23          	sd	a5,-40(s0)
ffffffe000201e0c:	fd843783          	ld	a5,-40(s0)
ffffffe000201e10:	fcf43823          	sd	a5,-48(s0)
    // printk("bad addr = 0x%x\n", bad_addr);
    struct vm_area_struct *vma = find_vma(current->mm,bad_addr);    //查找bad_addr是否在某个vma中
ffffffe000201e14:	00007797          	auipc	a5,0x7
ffffffe000201e18:	1fc78793          	addi	a5,a5,508 # ffffffe000209010 <current>
ffffffe000201e1c:	0007b783          	ld	a5,0(a5)
ffffffe000201e20:	0c87b783          	ld	a5,200(a5)
ffffffe000201e24:	fe043583          	ld	a1,-32(s0)
ffffffe000201e28:	00078513          	mv	a0,a5
ffffffe000201e2c:	fa0ff0ef          	jal	ffffffe0002015cc <find_vma>
ffffffe000201e30:	fca43423          	sd	a0,-56(s0)
    if(vma == NULL) {
ffffffe000201e34:	fc843783          	ld	a5,-56(s0)
ffffffe000201e38:	04079063          	bnez	a5,ffffffe000201e78 <do_page_fault+0x98>
        // 非预期错误
        Err("Can't find vma in address %lx! pid: %d\n", bad_addr, current->pid);
ffffffe000201e3c:	00007797          	auipc	a5,0x7
ffffffe000201e40:	1d478793          	addi	a5,a5,468 # ffffffe000209010 <current>
ffffffe000201e44:	0007b783          	ld	a5,0(a5)
ffffffe000201e48:	0187b783          	ld	a5,24(a5)
ffffffe000201e4c:	fe043703          	ld	a4,-32(s0)
ffffffe000201e50:	00002697          	auipc	a3,0x2
ffffffe000201e54:	52068693          	addi	a3,a3,1312 # ffffffe000204370 <__func__.0>
ffffffe000201e58:	06700613          	li	a2,103
ffffffe000201e5c:	00002597          	auipc	a1,0x2
ffffffe000201e60:	29c58593          	addi	a1,a1,668 # ffffffe0002040f8 <_srodata+0xf8>
ffffffe000201e64:	00002517          	auipc	a0,0x2
ffffffe000201e68:	3ac50513          	addi	a0,a0,940 # ffffffe000204210 <_srodata+0x210>
ffffffe000201e6c:	6b0010ef          	jal	ffffffe00020351c <printk>
ffffffe000201e70:	00000013          	nop
ffffffe000201e74:	ffdff06f          	j	ffffffe000201e70 <do_page_fault+0x90>
    }
    uint64_t perm = vma->vm_flags;
ffffffe000201e78:	fc843783          	ld	a5,-56(s0)
ffffffe000201e7c:	0287b783          	ld	a5,40(a5)
ffffffe000201e80:	fcf43023          	sd	a5,-64(s0)
    if(vma != NULL){
ffffffe000201e84:	fc843783          	ld	a5,-56(s0)
ffffffe000201e88:	24078263          	beqz	a5,ffffffe0002020cc <do_page_fault+0x2ec>
        // 根据scause的值和vma的perm判断当前访问是否合法
        int perm = ((vma->vm_flags) & (~VM_ANON)) | 0xd1;
ffffffe000201e8c:	fc843783          	ld	a5,-56(s0)
ffffffe000201e90:	0287b783          	ld	a5,40(a5)
ffffffe000201e94:	0007879b          	sext.w	a5,a5
ffffffe000201e98:	0d17e793          	ori	a5,a5,209
ffffffe000201e9c:	0007879b          	sext.w	a5,a5
ffffffe000201ea0:	faf42e23          	sw	a5,-68(s0)
        int is_exec = !(perm & VM_EXEC == 0);
ffffffe000201ea4:	00100793          	li	a5,1
ffffffe000201ea8:	faf42c23          	sw	a5,-72(s0)
        int is_read = !(perm & VM_READ == 0);
ffffffe000201eac:	00100793          	li	a5,1
ffffffe000201eb0:	faf42a23          	sw	a5,-76(s0)
        int is_write = !(perm & VM_WRITE == 0);
ffffffe000201eb4:	00100793          	li	a5,1
ffffffe000201eb8:	faf42823          	sw	a5,-80(s0)
        int is_anon = vma->vm_flags & VM_ANON;
ffffffe000201ebc:	fc843783          	ld	a5,-56(s0)
ffffffe000201ec0:	0287b783          	ld	a5,40(a5)
ffffffe000201ec4:	0007879b          	sext.w	a5,a5
ffffffe000201ec8:	0017f793          	andi	a5,a5,1
ffffffe000201ecc:	faf42623          	sw	a5,-84(s0)
        if (scause == 12 && !is_exec){
ffffffe000201ed0:	fd043703          	ld	a4,-48(s0)
ffffffe000201ed4:	00c00793          	li	a5,12
ffffffe000201ed8:	04f71463          	bne	a4,a5,ffffffe000201f20 <do_page_fault+0x140>
ffffffe000201edc:	fb842783          	lw	a5,-72(s0)
ffffffe000201ee0:	0007879b          	sext.w	a5,a5
ffffffe000201ee4:	02079e63          	bnez	a5,ffffffe000201f20 <do_page_fault+0x140>
            // Instruction Page Fault，需要有exec权限
            Err("Instruction Page Fault, but perm is : read %d, write %d, exec %d\n", is_read, is_write, is_exec);
ffffffe000201ee8:	fb842683          	lw	a3,-72(s0)
ffffffe000201eec:	fb042783          	lw	a5,-80(s0)
ffffffe000201ef0:	fb442703          	lw	a4,-76(s0)
ffffffe000201ef4:	00068813          	mv	a6,a3
ffffffe000201ef8:	00002697          	auipc	a3,0x2
ffffffe000201efc:	47868693          	addi	a3,a3,1144 # ffffffe000204370 <__func__.0>
ffffffe000201f00:	07300613          	li	a2,115
ffffffe000201f04:	00002597          	auipc	a1,0x2
ffffffe000201f08:	1f458593          	addi	a1,a1,500 # ffffffe0002040f8 <_srodata+0xf8>
ffffffe000201f0c:	00002517          	auipc	a0,0x2
ffffffe000201f10:	34450513          	addi	a0,a0,836 # ffffffe000204250 <_srodata+0x250>
ffffffe000201f14:	608010ef          	jal	ffffffe00020351c <printk>
ffffffe000201f18:	00000013          	nop
ffffffe000201f1c:	ffdff06f          	j	ffffffe000201f18 <do_page_fault+0x138>
        }else if (scause == 13 && !is_read) {
ffffffe000201f20:	fd043703          	ld	a4,-48(s0)
ffffffe000201f24:	00d00793          	li	a5,13
ffffffe000201f28:	04f71463          	bne	a4,a5,ffffffe000201f70 <do_page_fault+0x190>
ffffffe000201f2c:	fb442783          	lw	a5,-76(s0)
ffffffe000201f30:	0007879b          	sext.w	a5,a5
ffffffe000201f34:	02079e63          	bnez	a5,ffffffe000201f70 <do_page_fault+0x190>
            // Load Page Fault， 需要有read权限
            Err("Load Page Fault, but perm is : read %d, write %d, exec %d\n", is_read, is_write, is_exec);
ffffffe000201f38:	fb842683          	lw	a3,-72(s0)
ffffffe000201f3c:	fb042783          	lw	a5,-80(s0)
ffffffe000201f40:	fb442703          	lw	a4,-76(s0)
ffffffe000201f44:	00068813          	mv	a6,a3
ffffffe000201f48:	00002697          	auipc	a3,0x2
ffffffe000201f4c:	42868693          	addi	a3,a3,1064 # ffffffe000204370 <__func__.0>
ffffffe000201f50:	07600613          	li	a2,118
ffffffe000201f54:	00002597          	auipc	a1,0x2
ffffffe000201f58:	1a458593          	addi	a1,a1,420 # ffffffe0002040f8 <_srodata+0xf8>
ffffffe000201f5c:	00002517          	auipc	a0,0x2
ffffffe000201f60:	35450513          	addi	a0,a0,852 # ffffffe0002042b0 <_srodata+0x2b0>
ffffffe000201f64:	5b8010ef          	jal	ffffffe00020351c <printk>
ffffffe000201f68:	00000013          	nop
ffffffe000201f6c:	ffdff06f          	j	ffffffe000201f68 <do_page_fault+0x188>
        }else if (scause == 15 && !is_write){
ffffffe000201f70:	fd043703          	ld	a4,-48(s0)
ffffffe000201f74:	00f00793          	li	a5,15
ffffffe000201f78:	04f71463          	bne	a4,a5,ffffffe000201fc0 <do_page_fault+0x1e0>
ffffffe000201f7c:	fb042783          	lw	a5,-80(s0)
ffffffe000201f80:	0007879b          	sext.w	a5,a5
ffffffe000201f84:	02079e63          	bnez	a5,ffffffe000201fc0 <do_page_fault+0x1e0>
            // Store/AMO Page Fault， 需要有write权限
            Err("Store/AMO Page Fault, but perm is : read %d, write %d, exec %d\n", is_read, is_write, is_exec);
ffffffe000201f88:	fb842683          	lw	a3,-72(s0)
ffffffe000201f8c:	fb042783          	lw	a5,-80(s0)
ffffffe000201f90:	fb442703          	lw	a4,-76(s0)
ffffffe000201f94:	00068813          	mv	a6,a3
ffffffe000201f98:	00002697          	auipc	a3,0x2
ffffffe000201f9c:	3d868693          	addi	a3,a3,984 # ffffffe000204370 <__func__.0>
ffffffe000201fa0:	07900613          	li	a2,121
ffffffe000201fa4:	00002597          	auipc	a1,0x2
ffffffe000201fa8:	15458593          	addi	a1,a1,340 # ffffffe0002040f8 <_srodata+0xf8>
ffffffe000201fac:	00002517          	auipc	a0,0x2
ffffffe000201fb0:	35c50513          	addi	a0,a0,860 # ffffffe000204308 <_srodata+0x308>
ffffffe000201fb4:	568010ef          	jal	ffffffe00020351c <printk>
ffffffe000201fb8:	00000013          	nop
ffffffe000201fbc:	ffdff06f          	j	ffffffe000201fb8 <do_page_fault+0x1d8>
        }
        // 权限没有错误
        uint64_t new_page = alloc_page();
ffffffe000201fc0:	96dfe0ef          	jal	ffffffe00020092c <alloc_page>
ffffffe000201fc4:	00050793          	mv	a5,a0
ffffffe000201fc8:	faf43023          	sd	a5,-96(s0)
        if (is_anon){
ffffffe000201fcc:	fac42783          	lw	a5,-84(s0)
ffffffe000201fd0:	0007879b          	sext.w	a5,a5
ffffffe000201fd4:	04078c63          	beqz	a5,ffffffe00020202c <do_page_fault+0x24c>
            // 是匿名空间，直接映射
            memset((void *)new_page, 0x0, PGSIZE); // 清空页内容
ffffffe000201fd8:	fa043783          	ld	a5,-96(s0)
ffffffe000201fdc:	00001637          	lui	a2,0x1
ffffffe000201fe0:	00000593          	li	a1,0
ffffffe000201fe4:	00078513          	mv	a0,a5
ffffffe000201fe8:	654010ef          	jal	ffffffe00020363c <memset>
            create_mapping(current->pgd,PGROUNDDOWN(bad_addr),(uint64_t)new_page-PA2VA_OFFSET,PGSIZE,perm);
ffffffe000201fec:	00007797          	auipc	a5,0x7
ffffffe000201ff0:	02478793          	addi	a5,a5,36 # ffffffe000209010 <current>
ffffffe000201ff4:	0007b783          	ld	a5,0(a5)
ffffffe000201ff8:	0b07b503          	ld	a0,176(a5)
ffffffe000201ffc:	fe043703          	ld	a4,-32(s0)
ffffffe000202000:	fffff7b7          	lui	a5,0xfffff
ffffffe000202004:	00f775b3          	and	a1,a4,a5
ffffffe000202008:	fa043703          	ld	a4,-96(s0)
ffffffe00020200c:	04100793          	li	a5,65
ffffffe000202010:	01f79793          	slli	a5,a5,0x1f
ffffffe000202014:	00f707b3          	add	a5,a4,a5
ffffffe000202018:	fbc42703          	lw	a4,-68(s0)
ffffffe00020201c:	000016b7          	lui	a3,0x1
ffffffe000202020:	00078613          	mv	a2,a5
ffffffe000202024:	388000ef          	jal	ffffffe0002023ac <create_mapping>
            begin_addr += num_page * PGSIZE;
            memcpy((void *)new_page, (void *)PGROUNDDOWN(begin_addr), PGSIZE);
            create_mapping(current->pgd,PGROUNDDOWN(bad_addr),(uint64_t)new_page-PA2VA_OFFSET,PGSIZE,perm);
        }
    }
ffffffe000202028:	0a40006f          	j	ffffffe0002020cc <do_page_fault+0x2ec>
            uint64_t begin_addr = (uint64_t)(_sramdisk) + vma->vm_pgoff;
ffffffe00020202c:	fc843783          	ld	a5,-56(s0)
ffffffe000202030:	0307b703          	ld	a4,48(a5) # fffffffffffff030 <VM_END+0xfffff030>
ffffffe000202034:	00004797          	auipc	a5,0x4
ffffffe000202038:	fcc78793          	addi	a5,a5,-52 # ffffffe000206000 <_sramdisk>
ffffffe00020203c:	00f707b3          	add	a5,a4,a5
ffffffe000202040:	f8f43c23          	sd	a5,-104(s0)
            uint64_t num_page = (bad_addr - vma->vm_start) / PGSIZE;
ffffffe000202044:	fc843783          	ld	a5,-56(s0)
ffffffe000202048:	0087b783          	ld	a5,8(a5)
ffffffe00020204c:	fe043703          	ld	a4,-32(s0)
ffffffe000202050:	40f707b3          	sub	a5,a4,a5
ffffffe000202054:	00c7d793          	srli	a5,a5,0xc
ffffffe000202058:	f8f43823          	sd	a5,-112(s0)
            begin_addr += num_page * PGSIZE;
ffffffe00020205c:	f9043783          	ld	a5,-112(s0)
ffffffe000202060:	00c79793          	slli	a5,a5,0xc
ffffffe000202064:	f9843703          	ld	a4,-104(s0)
ffffffe000202068:	00f707b3          	add	a5,a4,a5
ffffffe00020206c:	f8f43c23          	sd	a5,-104(s0)
            memcpy((void *)new_page, (void *)PGROUNDDOWN(begin_addr), PGSIZE);
ffffffe000202070:	fa043683          	ld	a3,-96(s0)
ffffffe000202074:	f9843703          	ld	a4,-104(s0)
ffffffe000202078:	fffff7b7          	lui	a5,0xfffff
ffffffe00020207c:	00f777b3          	and	a5,a4,a5
ffffffe000202080:	00001637          	lui	a2,0x1
ffffffe000202084:	00078593          	mv	a1,a5
ffffffe000202088:	00068513          	mv	a0,a3
ffffffe00020208c:	620010ef          	jal	ffffffe0002036ac <memcpy>
            create_mapping(current->pgd,PGROUNDDOWN(bad_addr),(uint64_t)new_page-PA2VA_OFFSET,PGSIZE,perm);
ffffffe000202090:	00007797          	auipc	a5,0x7
ffffffe000202094:	f8078793          	addi	a5,a5,-128 # ffffffe000209010 <current>
ffffffe000202098:	0007b783          	ld	a5,0(a5)
ffffffe00020209c:	0b07b503          	ld	a0,176(a5)
ffffffe0002020a0:	fe043703          	ld	a4,-32(s0)
ffffffe0002020a4:	fffff7b7          	lui	a5,0xfffff
ffffffe0002020a8:	00f775b3          	and	a1,a4,a5
ffffffe0002020ac:	fa043703          	ld	a4,-96(s0)
ffffffe0002020b0:	04100793          	li	a5,65
ffffffe0002020b4:	01f79793          	slli	a5,a5,0x1f
ffffffe0002020b8:	00f707b3          	add	a5,a4,a5
ffffffe0002020bc:	fbc42703          	lw	a4,-68(s0)
ffffffe0002020c0:	000016b7          	lui	a3,0x1
ffffffe0002020c4:	00078613          	mv	a2,a5
ffffffe0002020c8:	2e4000ef          	jal	ffffffe0002023ac <create_mapping>
ffffffe0002020cc:	00000013          	nop
ffffffe0002020d0:	07813083          	ld	ra,120(sp)
ffffffe0002020d4:	07013403          	ld	s0,112(sp)
ffffffe0002020d8:	08010113          	addi	sp,sp,128
ffffffe0002020dc:	00008067          	ret

ffffffe0002020e0 <setup_vm>:
#include <string.h>

/* early_pgtbl: 用于 setup_vm 进行 1GiB 的映射 */
uint64_t early_pgtbl[512] __attribute__((__aligned__(0x1000)));

void setup_vm() {
ffffffe0002020e0:	fe010113          	addi	sp,sp,-32
ffffffe0002020e4:	00113c23          	sd	ra,24(sp)
ffffffe0002020e8:	00813823          	sd	s0,16(sp)
ffffffe0002020ec:	02010413          	addi	s0,sp,32
     *     high bit 可以忽略
     *     中间 9 bit 作为 early_pgtbl 的 index
     *     低 30 bit 作为页内偏移，这里注意到 30 = 9 + 9 + 12，即我们只使用根页表，根页表的每个 entry 都对应 1GiB 的区域
     * 3. Page Table Entry 的权限 V | R | W | X 位设置为 1
    **/
    memset(early_pgtbl, 0x0, PGSIZE); // 初始化pgtbl
ffffffe0002020f0:	00001637          	lui	a2,0x1
ffffffe0002020f4:	00000593          	li	a1,0
ffffffe0002020f8:	00008517          	auipc	a0,0x8
ffffffe0002020fc:	f0850513          	addi	a0,a0,-248 # ffffffe00020a000 <early_pgtbl>
ffffffe000202100:	53c010ef          	jal	ffffffe00020363c <memset>
    uint64_t va = PHY_START; // 等值映射
ffffffe000202104:	00100793          	li	a5,1
ffffffe000202108:	01f79793          	slli	a5,a5,0x1f
ffffffe00020210c:	fef43423          	sd	a5,-24(s0)
    uint64_t pa = PHY_START; // 偏移映射
ffffffe000202110:	00100793          	li	a5,1
ffffffe000202114:	01f79793          	slli	a5,a5,0x1f
ffffffe000202118:	fef43023          	sd	a5,-32(s0)
    // 中间 9 bit 作为 early_pgtbl 的 index
    // 权限：后四位XWRV都为1
    early_pgtbl[(va >> 30) & 0x1ff] = (((pa >> 30) & 0x3ffffff)<<28) | 0xf; // 映射大小为1GB，取PPN[2],即30-55一部分
ffffffe00020211c:	fe043783          	ld	a5,-32(s0)
ffffffe000202120:	01e7d793          	srli	a5,a5,0x1e
ffffffe000202124:	01c79713          	slli	a4,a5,0x1c
ffffffe000202128:	040007b7          	lui	a5,0x4000
ffffffe00020212c:	fff78793          	addi	a5,a5,-1 # 3ffffff <TIMECLOCK+0x367697f>
ffffffe000202130:	01c79793          	slli	a5,a5,0x1c
ffffffe000202134:	00f77733          	and	a4,a4,a5
ffffffe000202138:	fe843783          	ld	a5,-24(s0)
ffffffe00020213c:	01e7d793          	srli	a5,a5,0x1e
ffffffe000202140:	1ff7f793          	andi	a5,a5,511
ffffffe000202144:	00f76713          	ori	a4,a4,15
ffffffe000202148:	00008697          	auipc	a3,0x8
ffffffe00020214c:	eb868693          	addi	a3,a3,-328 # ffffffe00020a000 <early_pgtbl>
ffffffe000202150:	00379793          	slli	a5,a5,0x3
ffffffe000202154:	00f687b3          	add	a5,a3,a5
ffffffe000202158:	00e7b023          	sd	a4,0(a5)
    va = VM_START; // 偏移映射
ffffffe00020215c:	fff00793          	li	a5,-1
ffffffe000202160:	02579793          	slli	a5,a5,0x25
ffffffe000202164:	fef43423          	sd	a5,-24(s0)
    early_pgtbl[(va >> 30) & 0x1ff] = (((pa >> 30) & 0x3ffffff)<<28) | 0xf;
ffffffe000202168:	fe043783          	ld	a5,-32(s0)
ffffffe00020216c:	01e7d793          	srli	a5,a5,0x1e
ffffffe000202170:	01c79713          	slli	a4,a5,0x1c
ffffffe000202174:	040007b7          	lui	a5,0x4000
ffffffe000202178:	fff78793          	addi	a5,a5,-1 # 3ffffff <TIMECLOCK+0x367697f>
ffffffe00020217c:	01c79793          	slli	a5,a5,0x1c
ffffffe000202180:	00f77733          	and	a4,a4,a5
ffffffe000202184:	fe843783          	ld	a5,-24(s0)
ffffffe000202188:	01e7d793          	srli	a5,a5,0x1e
ffffffe00020218c:	1ff7f793          	andi	a5,a5,511
ffffffe000202190:	00f76713          	ori	a4,a4,15
ffffffe000202194:	00008697          	auipc	a3,0x8
ffffffe000202198:	e6c68693          	addi	a3,a3,-404 # ffffffe00020a000 <early_pgtbl>
ffffffe00020219c:	00379793          	slli	a5,a5,0x3
ffffffe0002021a0:	00f687b3          	add	a5,a3,a5
ffffffe0002021a4:	00e7b023          	sd	a4,0(a5)
    printk("...set up vm done!\n");
ffffffe0002021a8:	00002517          	auipc	a0,0x2
ffffffe0002021ac:	1d850513          	addi	a0,a0,472 # ffffffe000204380 <__func__.0+0x10>
ffffffe0002021b0:	36c010ef          	jal	ffffffe00020351c <printk>
}
ffffffe0002021b4:	00000013          	nop
ffffffe0002021b8:	01813083          	ld	ra,24(sp)
ffffffe0002021bc:	01013403          	ld	s0,16(sp)
ffffffe0002021c0:	02010113          	addi	sp,sp,32
ffffffe0002021c4:	00008067          	ret

ffffffe0002021c8 <setup_vm_final>:

/* swapper_pg_dir: kernel pagetable 根目录，在 setup_vm_final 进行映射 */
uint64_t swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

void setup_vm_final() {
ffffffe0002021c8:	fd010113          	addi	sp,sp,-48
ffffffe0002021cc:	02113423          	sd	ra,40(sp)
ffffffe0002021d0:	02813023          	sd	s0,32(sp)
ffffffe0002021d4:	03010413          	addi	s0,sp,48
    memset(swapper_pg_dir, 0x0, PGSIZE); // 清空根页表
ffffffe0002021d8:	00001637          	lui	a2,0x1
ffffffe0002021dc:	00000593          	li	a1,0
ffffffe0002021e0:	00009517          	auipc	a0,0x9
ffffffe0002021e4:	e2050513          	addi	a0,a0,-480 # ffffffe00020b000 <swapper_pg_dir>
ffffffe0002021e8:	454010ef          	jal	ffffffe00020363c <memset>
    // No OpenSBI mapping required
    uint64_t va = VM_START + OPENSBI_SIZE; // vmlinux.lds-MEMORY
ffffffe0002021ec:	f00017b7          	lui	a5,0xf0001
ffffffe0002021f0:	00979793          	slli	a5,a5,0x9
ffffffe0002021f4:	fef43423          	sd	a5,-24(s0)
    uint64_t pa = PHY_START + OPENSBI_SIZE;
ffffffe0002021f8:	40100793          	li	a5,1025
ffffffe0002021fc:	01579793          	slli	a5,a5,0x15
ffffffe000202200:	fef43023          	sd	a5,-32(s0)
    // mapping kernel text X|-|R|V
    create_mapping(swapper_pg_dir, va, pa, _srodata - _stext, 0xB);
ffffffe000202204:	00002717          	auipc	a4,0x2
ffffffe000202208:	dfc70713          	addi	a4,a4,-516 # ffffffe000204000 <_srodata>
ffffffe00020220c:	ffffe797          	auipc	a5,0xffffe
ffffffe000202210:	df478793          	addi	a5,a5,-524 # ffffffe000200000 <_skernel>
ffffffe000202214:	40f707b3          	sub	a5,a4,a5
ffffffe000202218:	00b00713          	li	a4,11
ffffffe00020221c:	00078693          	mv	a3,a5
ffffffe000202220:	fe043603          	ld	a2,-32(s0)
ffffffe000202224:	fe843583          	ld	a1,-24(s0)
ffffffe000202228:	00009517          	auipc	a0,0x9
ffffffe00020222c:	dd850513          	addi	a0,a0,-552 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000202230:	17c000ef          	jal	ffffffe0002023ac <create_mapping>
    printk("...kernel text mapping done\n");
ffffffe000202234:	00002517          	auipc	a0,0x2
ffffffe000202238:	16450513          	addi	a0,a0,356 # ffffffe000204398 <__func__.0+0x28>
ffffffe00020223c:	2e0010ef          	jal	ffffffe00020351c <printk>

    // mapping kernel rodata -|-|R|V
    va += _srodata - _stext;
ffffffe000202240:	00002717          	auipc	a4,0x2
ffffffe000202244:	dc070713          	addi	a4,a4,-576 # ffffffe000204000 <_srodata>
ffffffe000202248:	ffffe797          	auipc	a5,0xffffe
ffffffe00020224c:	db878793          	addi	a5,a5,-584 # ffffffe000200000 <_skernel>
ffffffe000202250:	40f707b3          	sub	a5,a4,a5
ffffffe000202254:	00078713          	mv	a4,a5
ffffffe000202258:	fe843783          	ld	a5,-24(s0)
ffffffe00020225c:	00e787b3          	add	a5,a5,a4
ffffffe000202260:	fef43423          	sd	a5,-24(s0)
    pa += _srodata - _stext;
ffffffe000202264:	00002717          	auipc	a4,0x2
ffffffe000202268:	d9c70713          	addi	a4,a4,-612 # ffffffe000204000 <_srodata>
ffffffe00020226c:	ffffe797          	auipc	a5,0xffffe
ffffffe000202270:	d9478793          	addi	a5,a5,-620 # ffffffe000200000 <_skernel>
ffffffe000202274:	40f707b3          	sub	a5,a4,a5
ffffffe000202278:	00078713          	mv	a4,a5
ffffffe00020227c:	fe043783          	ld	a5,-32(s0)
ffffffe000202280:	00e787b3          	add	a5,a5,a4
ffffffe000202284:	fef43023          	sd	a5,-32(s0)
    create_mapping(swapper_pg_dir, va, pa, _sdata - _srodata, 0x3);
ffffffe000202288:	00003717          	auipc	a4,0x3
ffffffe00020228c:	d7870713          	addi	a4,a4,-648 # ffffffe000205000 <TIMECLOCK>
ffffffe000202290:	00002797          	auipc	a5,0x2
ffffffe000202294:	d7078793          	addi	a5,a5,-656 # ffffffe000204000 <_srodata>
ffffffe000202298:	40f707b3          	sub	a5,a4,a5
ffffffe00020229c:	00300713          	li	a4,3
ffffffe0002022a0:	00078693          	mv	a3,a5
ffffffe0002022a4:	fe043603          	ld	a2,-32(s0)
ffffffe0002022a8:	fe843583          	ld	a1,-24(s0)
ffffffe0002022ac:	00009517          	auipc	a0,0x9
ffffffe0002022b0:	d5450513          	addi	a0,a0,-684 # ffffffe00020b000 <swapper_pg_dir>
ffffffe0002022b4:	0f8000ef          	jal	ffffffe0002023ac <create_mapping>
    printk("...kernel rodata mapping done\n");
ffffffe0002022b8:	00002517          	auipc	a0,0x2
ffffffe0002022bc:	10050513          	addi	a0,a0,256 # ffffffe0002043b8 <__func__.0+0x48>
ffffffe0002022c0:	25c010ef          	jal	ffffffe00020351c <printk>

    // mapping other memory -|W|R|V
    va += _sdata - _srodata;
ffffffe0002022c4:	00003717          	auipc	a4,0x3
ffffffe0002022c8:	d3c70713          	addi	a4,a4,-708 # ffffffe000205000 <TIMECLOCK>
ffffffe0002022cc:	00002797          	auipc	a5,0x2
ffffffe0002022d0:	d3478793          	addi	a5,a5,-716 # ffffffe000204000 <_srodata>
ffffffe0002022d4:	40f707b3          	sub	a5,a4,a5
ffffffe0002022d8:	00078713          	mv	a4,a5
ffffffe0002022dc:	fe843783          	ld	a5,-24(s0)
ffffffe0002022e0:	00e787b3          	add	a5,a5,a4
ffffffe0002022e4:	fef43423          	sd	a5,-24(s0)
    pa += _sdata - _srodata;
ffffffe0002022e8:	00003717          	auipc	a4,0x3
ffffffe0002022ec:	d1870713          	addi	a4,a4,-744 # ffffffe000205000 <TIMECLOCK>
ffffffe0002022f0:	00002797          	auipc	a5,0x2
ffffffe0002022f4:	d1078793          	addi	a5,a5,-752 # ffffffe000204000 <_srodata>
ffffffe0002022f8:	40f707b3          	sub	a5,a4,a5
ffffffe0002022fc:	00078713          	mv	a4,a5
ffffffe000202300:	fe043783          	ld	a5,-32(s0)
ffffffe000202304:	00e787b3          	add	a5,a5,a4
ffffffe000202308:	fef43023          	sd	a5,-32(s0)
    create_mapping(swapper_pg_dir, va, pa, PHY_SIZE - (_sdata - _stext), 0x7);
ffffffe00020230c:	00003717          	auipc	a4,0x3
ffffffe000202310:	cf470713          	addi	a4,a4,-780 # ffffffe000205000 <TIMECLOCK>
ffffffe000202314:	ffffe797          	auipc	a5,0xffffe
ffffffe000202318:	cec78793          	addi	a5,a5,-788 # ffffffe000200000 <_skernel>
ffffffe00020231c:	40f707b3          	sub	a5,a4,a5
ffffffe000202320:	08000737          	lui	a4,0x8000
ffffffe000202324:	40f707b3          	sub	a5,a4,a5
ffffffe000202328:	00700713          	li	a4,7
ffffffe00020232c:	00078693          	mv	a3,a5
ffffffe000202330:	fe043603          	ld	a2,-32(s0)
ffffffe000202334:	fe843583          	ld	a1,-24(s0)
ffffffe000202338:	00009517          	auipc	a0,0x9
ffffffe00020233c:	cc850513          	addi	a0,a0,-824 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000202340:	06c000ef          	jal	ffffffe0002023ac <create_mapping>
    printk("...other memory mapping done\n");
ffffffe000202344:	00002517          	auipc	a0,0x2
ffffffe000202348:	09450513          	addi	a0,a0,148 # ffffffe0002043d8 <__func__.0+0x68>
ffffffe00020234c:	1d0010ef          	jal	ffffffe00020351c <printk>

    // set satp with swapper_pg_dir
    // 注意satp中需要存放PPN：1. 是物理地址（需要减去PA2VA_OFFSET）；2. 是PPN（需要移除page offset）
    uint64_t _satp = (((unsigned long)swapper_pg_dir - PA2VA_OFFSET) >> 12) | (8L << 60); // 设置mode
ffffffe000202350:	00009717          	auipc	a4,0x9
ffffffe000202354:	cb070713          	addi	a4,a4,-848 # ffffffe00020b000 <swapper_pg_dir>
ffffffe000202358:	04100793          	li	a5,65
ffffffe00020235c:	01f79793          	slli	a5,a5,0x1f
ffffffe000202360:	00f707b3          	add	a5,a4,a5
ffffffe000202364:	00c7d713          	srli	a4,a5,0xc
ffffffe000202368:	fff00793          	li	a5,-1
ffffffe00020236c:	03f79793          	slli	a5,a5,0x3f
ffffffe000202370:	00f767b3          	or	a5,a4,a5
ffffffe000202374:	fcf43c23          	sd	a5,-40(s0)
    csr_write(satp, _satp);
ffffffe000202378:	fd843783          	ld	a5,-40(s0)
ffffffe00020237c:	fcf43823          	sd	a5,-48(s0)
ffffffe000202380:	fd043783          	ld	a5,-48(s0)
ffffffe000202384:	18079073          	csrw	satp,a5

    // flush TLB
    asm volatile("sfence.vma zero, zero");
ffffffe000202388:	12000073          	sfence.vma

    printk("...setup vm final done!\n");
ffffffe00020238c:	00002517          	auipc	a0,0x2
ffffffe000202390:	06c50513          	addi	a0,a0,108 # ffffffe0002043f8 <__func__.0+0x88>
ffffffe000202394:	188010ef          	jal	ffffffe00020351c <printk>
    return;
ffffffe000202398:	00000013          	nop
}
ffffffe00020239c:	02813083          	ld	ra,40(sp)
ffffffe0002023a0:	02013403          	ld	s0,32(sp)
ffffffe0002023a4:	03010113          	addi	sp,sp,48
ffffffe0002023a8:	00008067          	ret

ffffffe0002023ac <create_mapping>:


/* 创建多级页表映射关系 */
/* 不要修改该接口的参数和返回值 */
void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm) {
ffffffe0002023ac:	f5010113          	addi	sp,sp,-176
ffffffe0002023b0:	0a113423          	sd	ra,168(sp)
ffffffe0002023b4:	0a813023          	sd	s0,160(sp)
ffffffe0002023b8:	0b010413          	addi	s0,sp,176
ffffffe0002023bc:	f8a43423          	sd	a0,-120(s0)
ffffffe0002023c0:	f8b43023          	sd	a1,-128(s0)
ffffffe0002023c4:	f6c43c23          	sd	a2,-136(s0)
ffffffe0002023c8:	f6d43823          	sd	a3,-144(s0)
ffffffe0002023cc:	f6e43423          	sd	a4,-152(s0)
     *
     * 创建多级页表的时候可以使用 kalloc() 来获取一页作为页表目录
     * 可以使用 V bit 来判断页表项是否存在
    **/
    uint64_t vpn[3];          // 虚拟页号，分别表示三级页表的索引
    uint64_t curr_pa = pa;    // 当前物理地址
ffffffe0002023d0:	f7843783          	ld	a5,-136(s0)
ffffffe0002023d4:	fef43423          	sd	a5,-24(s0)
    uint64_t curr_va = va;    // 当前虚拟地址
ffffffe0002023d8:	f8043783          	ld	a5,-128(s0)
ffffffe0002023dc:	fef43023          	sd	a5,-32(s0)
    uint64_t end_va = va + sz; // 计算结束的虚拟地址
ffffffe0002023e0:	f8043703          	ld	a4,-128(s0)
ffffffe0002023e4:	f7043783          	ld	a5,-144(s0)
ffffffe0002023e8:	00f707b3          	add	a5,a4,a5
ffffffe0002023ec:	fcf43c23          	sd	a5,-40(s0)
    uint64_t end_pa = pa + sz;
ffffffe0002023f0:	f7843703          	ld	a4,-136(s0)
ffffffe0002023f4:	f7043783          	ld	a5,-144(s0)
ffffffe0002023f8:	00f707b3          	add	a5,a4,a5
ffffffe0002023fc:	fcf43823          	sd	a5,-48(s0)
    uint64_t *curr_tbl = pgtbl;
ffffffe000202400:	f8843783          	ld	a5,-120(s0)
ffffffe000202404:	fcf43423          	sd	a5,-56(s0)
    Info("root[0x%x], [0x%lx, 0x%lx)->[0x%lx, 0x%lx), perm=%x", pgtbl, pa, end_pa, va, end_va, perm);
ffffffe000202408:	f6843783          	ld	a5,-152(s0)
ffffffe00020240c:	00f13423          	sd	a5,8(sp)
ffffffe000202410:	fd843783          	ld	a5,-40(s0)
ffffffe000202414:	00f13023          	sd	a5,0(sp)
ffffffe000202418:	f8043883          	ld	a7,-128(s0)
ffffffe00020241c:	fd043803          	ld	a6,-48(s0)
ffffffe000202420:	f7843783          	ld	a5,-136(s0)
ffffffe000202424:	f8843703          	ld	a4,-120(s0)
ffffffe000202428:	00002697          	auipc	a3,0x2
ffffffe00020242c:	04868693          	addi	a3,a3,72 # ffffffe000204470 <__func__.0>
ffffffe000202430:	06000613          	li	a2,96
ffffffe000202434:	00002597          	auipc	a1,0x2
ffffffe000202438:	fe458593          	addi	a1,a1,-28 # ffffffe000204418 <__func__.0+0xa8>
ffffffe00020243c:	00002517          	auipc	a0,0x2
ffffffe000202440:	fe450513          	addi	a0,a0,-28 # ffffffe000204420 <__func__.0+0xb0>
ffffffe000202444:	0d8010ef          	jal	ffffffe00020351c <printk>

    while(curr_va < end_va){
ffffffe000202448:	1940006f          	j	ffffffe0002025dc <create_mapping+0x230>
        // 获取各个层级的vpn
        vpn[0] = (curr_va >> 12) & 0x1ff;
ffffffe00020244c:	fe043783          	ld	a5,-32(s0)
ffffffe000202450:	00c7d793          	srli	a5,a5,0xc
ffffffe000202454:	1ff7f793          	andi	a5,a5,511
ffffffe000202458:	f8f43c23          	sd	a5,-104(s0)
        vpn[1] = (curr_va >> 21) & 0x1ff;
ffffffe00020245c:	fe043783          	ld	a5,-32(s0)
ffffffe000202460:	0157d793          	srli	a5,a5,0x15
ffffffe000202464:	1ff7f793          	andi	a5,a5,511
ffffffe000202468:	faf43023          	sd	a5,-96(s0)
        vpn[2] = (curr_va >> 30) & 0x1ff;
ffffffe00020246c:	fe043783          	ld	a5,-32(s0)
ffffffe000202470:	01e7d793          	srli	a5,a5,0x1e
ffffffe000202474:	1ff7f793          	andi	a5,a5,511
ffffffe000202478:	faf43423          	sd	a5,-88(s0)

        uint64_t *curr_pgtbl = pgtbl;
ffffffe00020247c:	f8843783          	ld	a5,-120(s0)
ffffffe000202480:	fcf43023          	sd	a5,-64(s0)
        if (!(curr_pgtbl[vpn[2]] & 0x1)) { // 如果V bit为0，不存在
ffffffe000202484:	fa843783          	ld	a5,-88(s0)
ffffffe000202488:	00379793          	slli	a5,a5,0x3
ffffffe00020248c:	fc043703          	ld	a4,-64(s0)
ffffffe000202490:	00f707b3          	add	a5,a4,a5
ffffffe000202494:	0007b783          	ld	a5,0(a5)
ffffffe000202498:	0017f793          	andi	a5,a5,1
ffffffe00020249c:	04079263          	bnez	a5,ffffffe0002024e0 <create_mapping+0x134>
            uint64_t *new_pgd = (uint64_t*)(alloc_page() - PA2VA_OFFSET); // 物理地址
ffffffe0002024a0:	c8cfe0ef          	jal	ffffffe00020092c <alloc_page>
ffffffe0002024a4:	00050793          	mv	a5,a0
ffffffe0002024a8:	00078713          	mv	a4,a5
ffffffe0002024ac:	04100793          	li	a5,65
ffffffe0002024b0:	01f79793          	slli	a5,a5,0x1f
ffffffe0002024b4:	00f707b3          	add	a5,a4,a5
ffffffe0002024b8:	faf43c23          	sd	a5,-72(s0)
            curr_pgtbl[vpn[2]] = (((uint64_t)new_pgd >> 12) << 10 | 0x1);
ffffffe0002024bc:	fb843783          	ld	a5,-72(s0)
ffffffe0002024c0:	00c7d793          	srli	a5,a5,0xc
ffffffe0002024c4:	00a79713          	slli	a4,a5,0xa
ffffffe0002024c8:	fa843783          	ld	a5,-88(s0)
ffffffe0002024cc:	00379793          	slli	a5,a5,0x3
ffffffe0002024d0:	fc043683          	ld	a3,-64(s0)
ffffffe0002024d4:	00f687b3          	add	a5,a3,a5
ffffffe0002024d8:	00176713          	ori	a4,a4,1
ffffffe0002024dc:	00e7b023          	sd	a4,0(a5)
        }
        // curr_pgtbl = (uint64_t *)((curr_pgtbl[vpn[2]] >> 10) << 12) + PA2VA_OFFSET; // 虚拟地址
        curr_pgtbl = ((curr_pgtbl[vpn[2]] >> 10) << 12) + PA2VA_OFFSET; // 虚拟地址
ffffffe0002024e0:	fa843783          	ld	a5,-88(s0)
ffffffe0002024e4:	00379793          	slli	a5,a5,0x3
ffffffe0002024e8:	fc043703          	ld	a4,-64(s0)
ffffffe0002024ec:	00f707b3          	add	a5,a4,a5
ffffffe0002024f0:	0007b783          	ld	a5,0(a5)
ffffffe0002024f4:	00a7d793          	srli	a5,a5,0xa
ffffffe0002024f8:	00c79713          	slli	a4,a5,0xc
ffffffe0002024fc:	fbf00793          	li	a5,-65
ffffffe000202500:	01f79793          	slli	a5,a5,0x1f
ffffffe000202504:	00f707b3          	add	a5,a4,a5
ffffffe000202508:	fcf43023          	sd	a5,-64(s0)
        // 处理page middle directory和pgd相似
        if (!(curr_pgtbl[vpn[1]] & 0x1)) { // 如果V bit为0，不存在
ffffffe00020250c:	fa043783          	ld	a5,-96(s0)
ffffffe000202510:	00379793          	slli	a5,a5,0x3
ffffffe000202514:	fc043703          	ld	a4,-64(s0)
ffffffe000202518:	00f707b3          	add	a5,a4,a5
ffffffe00020251c:	0007b783          	ld	a5,0(a5)
ffffffe000202520:	0017f793          	andi	a5,a5,1
ffffffe000202524:	04079263          	bnez	a5,ffffffe000202568 <create_mapping+0x1bc>
            uint64_t *new_pmd = (uint64_t*)(alloc_page() - PA2VA_OFFSET); // 物理地址
ffffffe000202528:	c04fe0ef          	jal	ffffffe00020092c <alloc_page>
ffffffe00020252c:	00050793          	mv	a5,a0
ffffffe000202530:	00078713          	mv	a4,a5
ffffffe000202534:	04100793          	li	a5,65
ffffffe000202538:	01f79793          	slli	a5,a5,0x1f
ffffffe00020253c:	00f707b3          	add	a5,a4,a5
ffffffe000202540:	faf43823          	sd	a5,-80(s0)
            curr_pgtbl[vpn[1]] = (((uint64_t)new_pmd >> 12) << 10 | 0x1);
ffffffe000202544:	fb043783          	ld	a5,-80(s0)
ffffffe000202548:	00c7d793          	srli	a5,a5,0xc
ffffffe00020254c:	00a79713          	slli	a4,a5,0xa
ffffffe000202550:	fa043783          	ld	a5,-96(s0)
ffffffe000202554:	00379793          	slli	a5,a5,0x3
ffffffe000202558:	fc043683          	ld	a3,-64(s0)
ffffffe00020255c:	00f687b3          	add	a5,a3,a5
ffffffe000202560:	00176713          	ori	a4,a4,1
ffffffe000202564:	00e7b023          	sd	a4,0(a5)
        }
        // curr_pgtbl = (uint64_t *)((curr_pgtbl[vpn[1]] >> 10) << 12) + PA2VA_OFFSET; //虚拟地址
        curr_pgtbl = ((curr_pgtbl[vpn[1]] >> 10) << 12) + PA2VA_OFFSET; // 虚拟地址
ffffffe000202568:	fa043783          	ld	a5,-96(s0)
ffffffe00020256c:	00379793          	slli	a5,a5,0x3
ffffffe000202570:	fc043703          	ld	a4,-64(s0)
ffffffe000202574:	00f707b3          	add	a5,a4,a5
ffffffe000202578:	0007b783          	ld	a5,0(a5)
ffffffe00020257c:	00a7d793          	srli	a5,a5,0xa
ffffffe000202580:	00c79713          	slli	a4,a5,0xc
ffffffe000202584:	fbf00793          	li	a5,-65
ffffffe000202588:	01f79793          	slli	a5,a5,0x1f
ffffffe00020258c:	00f707b3          	add	a5,a4,a5
ffffffe000202590:	fcf43023          	sd	a5,-64(s0)
        // 最后是真正的pte
        curr_pgtbl[vpn[0]] = ((curr_pa >> 12) << 10) | perm; // 设置prem，注意pte中存放的永远是物理地址
ffffffe000202594:	fe843783          	ld	a5,-24(s0)
ffffffe000202598:	00c7d793          	srli	a5,a5,0xc
ffffffe00020259c:	00a79693          	slli	a3,a5,0xa
ffffffe0002025a0:	f9843783          	ld	a5,-104(s0)
ffffffe0002025a4:	00379793          	slli	a5,a5,0x3
ffffffe0002025a8:	fc043703          	ld	a4,-64(s0)
ffffffe0002025ac:	00f707b3          	add	a5,a4,a5
ffffffe0002025b0:	f6843703          	ld	a4,-152(s0)
ffffffe0002025b4:	00e6e733          	or	a4,a3,a4
ffffffe0002025b8:	00e7b023          	sd	a4,0(a5)

        curr_pa += PGSIZE;
ffffffe0002025bc:	fe843703          	ld	a4,-24(s0)
ffffffe0002025c0:	000017b7          	lui	a5,0x1
ffffffe0002025c4:	00f707b3          	add	a5,a4,a5
ffffffe0002025c8:	fef43423          	sd	a5,-24(s0)
        curr_va += PGSIZE;
ffffffe0002025cc:	fe043703          	ld	a4,-32(s0)
ffffffe0002025d0:	000017b7          	lui	a5,0x1
ffffffe0002025d4:	00f707b3          	add	a5,a4,a5
ffffffe0002025d8:	fef43023          	sd	a5,-32(s0)
    while(curr_va < end_va){
ffffffe0002025dc:	fe043703          	ld	a4,-32(s0)
ffffffe0002025e0:	fd843783          	ld	a5,-40(s0)
ffffffe0002025e4:	e6f764e3          	bltu	a4,a5,ffffffe00020244c <create_mapping+0xa0>
    }
ffffffe0002025e8:	00000013          	nop
ffffffe0002025ec:	00000013          	nop
ffffffe0002025f0:	0a813083          	ld	ra,168(sp)
ffffffe0002025f4:	0a013403          	ld	s0,160(sp)
ffffffe0002025f8:	0b010113          	addi	sp,sp,176
ffffffe0002025fc:	00008067          	ret

ffffffe000202600 <start_kernel>:
#include "sbi.h"
#include "proc.h"

extern void test();

int start_kernel() {
ffffffe000202600:	ff010113          	addi	sp,sp,-16
ffffffe000202604:	00113423          	sd	ra,8(sp)
ffffffe000202608:	00813023          	sd	s0,0(sp)
ffffffe00020260c:	01010413          	addi	s0,sp,16
    printk(GREEN "2024" CLEAR);
ffffffe000202610:	00002517          	auipc	a0,0x2
ffffffe000202614:	e7050513          	addi	a0,a0,-400 # ffffffe000204480 <__func__.0+0x10>
ffffffe000202618:	705000ef          	jal	ffffffe00020351c <printk>
    printk(GREEN " ZJU Operating System\n" CLEAR);
ffffffe00020261c:	00002517          	auipc	a0,0x2
ffffffe000202620:	e7450513          	addi	a0,a0,-396 # ffffffe000204490 <__func__.0+0x20>
ffffffe000202624:	6f9000ef          	jal	ffffffe00020351c <printk>
    schedule();
ffffffe000202628:	b21fe0ef          	jal	ffffffe000201148 <schedule>
    test();
ffffffe00020262c:	01c000ef          	jal	ffffffe000202648 <test>
    return 0;
ffffffe000202630:	00000793          	li	a5,0
}
ffffffe000202634:	00078513          	mv	a0,a5
ffffffe000202638:	00813083          	ld	ra,8(sp)
ffffffe00020263c:	00013403          	ld	s0,0(sp)
ffffffe000202640:	01010113          	addi	sp,sp,16
ffffffe000202644:	00008067          	ret

ffffffe000202648 <test>:
#include "printk.h"

void test() {
ffffffe000202648:	fe010113          	addi	sp,sp,-32
ffffffe00020264c:	00813c23          	sd	s0,24(sp)
ffffffe000202650:	02010413          	addi	s0,sp,32
    int i = 0;
ffffffe000202654:	fe042623          	sw	zero,-20(s0)
    while (1) {
        if ((++i) % 100000000 == 0) {
ffffffe000202658:	fec42783          	lw	a5,-20(s0)
ffffffe00020265c:	0017879b          	addiw	a5,a5,1 # 1001 <PGSIZE+0x1>
ffffffe000202660:	fef42623          	sw	a5,-20(s0)
ffffffe000202664:	fec42783          	lw	a5,-20(s0)
ffffffe000202668:	00078713          	mv	a4,a5
ffffffe00020266c:	05f5e7b7          	lui	a5,0x5f5e
ffffffe000202670:	1007879b          	addiw	a5,a5,256 # 5f5e100 <TIMECLOCK+0x55d4a80>
ffffffe000202674:	02f767bb          	remw	a5,a4,a5
ffffffe000202678:	0007879b          	sext.w	a5,a5
ffffffe00020267c:	fc079ee3          	bnez	a5,ffffffe000202658 <test+0x10>
            // printk("kernel is running!\n");
            i = 0;
ffffffe000202680:	fe042623          	sw	zero,-20(s0)
        if ((++i) % 100000000 == 0) {
ffffffe000202684:	fd5ff06f          	j	ffffffe000202658 <test+0x10>

ffffffe000202688 <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
ffffffe000202688:	fe010113          	addi	sp,sp,-32
ffffffe00020268c:	00113c23          	sd	ra,24(sp)
ffffffe000202690:	00813823          	sd	s0,16(sp)
ffffffe000202694:	02010413          	addi	s0,sp,32
ffffffe000202698:	00050793          	mv	a5,a0
ffffffe00020269c:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
ffffffe0002026a0:	fec42783          	lw	a5,-20(s0)
ffffffe0002026a4:	0ff7f793          	zext.b	a5,a5
ffffffe0002026a8:	00078513          	mv	a0,a5
ffffffe0002026ac:	94cff0ef          	jal	ffffffe0002017f8 <sbi_debug_console_write_byte>
    return (char)c;
ffffffe0002026b0:	fec42783          	lw	a5,-20(s0)
ffffffe0002026b4:	0ff7f793          	zext.b	a5,a5
ffffffe0002026b8:	0007879b          	sext.w	a5,a5
}
ffffffe0002026bc:	00078513          	mv	a0,a5
ffffffe0002026c0:	01813083          	ld	ra,24(sp)
ffffffe0002026c4:	01013403          	ld	s0,16(sp)
ffffffe0002026c8:	02010113          	addi	sp,sp,32
ffffffe0002026cc:	00008067          	ret

ffffffe0002026d0 <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
ffffffe0002026d0:	fe010113          	addi	sp,sp,-32
ffffffe0002026d4:	00813c23          	sd	s0,24(sp)
ffffffe0002026d8:	02010413          	addi	s0,sp,32
ffffffe0002026dc:	00050793          	mv	a5,a0
ffffffe0002026e0:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
ffffffe0002026e4:	fec42783          	lw	a5,-20(s0)
ffffffe0002026e8:	0007871b          	sext.w	a4,a5
ffffffe0002026ec:	02000793          	li	a5,32
ffffffe0002026f0:	02f70263          	beq	a4,a5,ffffffe000202714 <isspace+0x44>
ffffffe0002026f4:	fec42783          	lw	a5,-20(s0)
ffffffe0002026f8:	0007871b          	sext.w	a4,a5
ffffffe0002026fc:	00800793          	li	a5,8
ffffffe000202700:	00e7de63          	bge	a5,a4,ffffffe00020271c <isspace+0x4c>
ffffffe000202704:	fec42783          	lw	a5,-20(s0)
ffffffe000202708:	0007871b          	sext.w	a4,a5
ffffffe00020270c:	00d00793          	li	a5,13
ffffffe000202710:	00e7c663          	blt	a5,a4,ffffffe00020271c <isspace+0x4c>
ffffffe000202714:	00100793          	li	a5,1
ffffffe000202718:	0080006f          	j	ffffffe000202720 <isspace+0x50>
ffffffe00020271c:	00000793          	li	a5,0
}
ffffffe000202720:	00078513          	mv	a0,a5
ffffffe000202724:	01813403          	ld	s0,24(sp)
ffffffe000202728:	02010113          	addi	sp,sp,32
ffffffe00020272c:	00008067          	ret

ffffffe000202730 <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
ffffffe000202730:	fb010113          	addi	sp,sp,-80
ffffffe000202734:	04113423          	sd	ra,72(sp)
ffffffe000202738:	04813023          	sd	s0,64(sp)
ffffffe00020273c:	05010413          	addi	s0,sp,80
ffffffe000202740:	fca43423          	sd	a0,-56(s0)
ffffffe000202744:	fcb43023          	sd	a1,-64(s0)
ffffffe000202748:	00060793          	mv	a5,a2
ffffffe00020274c:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
ffffffe000202750:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
ffffffe000202754:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
ffffffe000202758:	fc843783          	ld	a5,-56(s0)
ffffffe00020275c:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
ffffffe000202760:	0100006f          	j	ffffffe000202770 <strtol+0x40>
        p++;
ffffffe000202764:	fd843783          	ld	a5,-40(s0)
ffffffe000202768:	00178793          	addi	a5,a5,1
ffffffe00020276c:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
ffffffe000202770:	fd843783          	ld	a5,-40(s0)
ffffffe000202774:	0007c783          	lbu	a5,0(a5)
ffffffe000202778:	0007879b          	sext.w	a5,a5
ffffffe00020277c:	00078513          	mv	a0,a5
ffffffe000202780:	f51ff0ef          	jal	ffffffe0002026d0 <isspace>
ffffffe000202784:	00050793          	mv	a5,a0
ffffffe000202788:	fc079ee3          	bnez	a5,ffffffe000202764 <strtol+0x34>
    }

    if (*p == '-') {
ffffffe00020278c:	fd843783          	ld	a5,-40(s0)
ffffffe000202790:	0007c783          	lbu	a5,0(a5)
ffffffe000202794:	00078713          	mv	a4,a5
ffffffe000202798:	02d00793          	li	a5,45
ffffffe00020279c:	00f71e63          	bne	a4,a5,ffffffe0002027b8 <strtol+0x88>
        neg = true;
ffffffe0002027a0:	00100793          	li	a5,1
ffffffe0002027a4:	fef403a3          	sb	a5,-25(s0)
        p++;
ffffffe0002027a8:	fd843783          	ld	a5,-40(s0)
ffffffe0002027ac:	00178793          	addi	a5,a5,1
ffffffe0002027b0:	fcf43c23          	sd	a5,-40(s0)
ffffffe0002027b4:	0240006f          	j	ffffffe0002027d8 <strtol+0xa8>
    } else if (*p == '+') {
ffffffe0002027b8:	fd843783          	ld	a5,-40(s0)
ffffffe0002027bc:	0007c783          	lbu	a5,0(a5)
ffffffe0002027c0:	00078713          	mv	a4,a5
ffffffe0002027c4:	02b00793          	li	a5,43
ffffffe0002027c8:	00f71863          	bne	a4,a5,ffffffe0002027d8 <strtol+0xa8>
        p++;
ffffffe0002027cc:	fd843783          	ld	a5,-40(s0)
ffffffe0002027d0:	00178793          	addi	a5,a5,1
ffffffe0002027d4:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
ffffffe0002027d8:	fbc42783          	lw	a5,-68(s0)
ffffffe0002027dc:	0007879b          	sext.w	a5,a5
ffffffe0002027e0:	06079c63          	bnez	a5,ffffffe000202858 <strtol+0x128>
        if (*p == '0') {
ffffffe0002027e4:	fd843783          	ld	a5,-40(s0)
ffffffe0002027e8:	0007c783          	lbu	a5,0(a5)
ffffffe0002027ec:	00078713          	mv	a4,a5
ffffffe0002027f0:	03000793          	li	a5,48
ffffffe0002027f4:	04f71e63          	bne	a4,a5,ffffffe000202850 <strtol+0x120>
            p++;
ffffffe0002027f8:	fd843783          	ld	a5,-40(s0)
ffffffe0002027fc:	00178793          	addi	a5,a5,1
ffffffe000202800:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
ffffffe000202804:	fd843783          	ld	a5,-40(s0)
ffffffe000202808:	0007c783          	lbu	a5,0(a5)
ffffffe00020280c:	00078713          	mv	a4,a5
ffffffe000202810:	07800793          	li	a5,120
ffffffe000202814:	00f70c63          	beq	a4,a5,ffffffe00020282c <strtol+0xfc>
ffffffe000202818:	fd843783          	ld	a5,-40(s0)
ffffffe00020281c:	0007c783          	lbu	a5,0(a5)
ffffffe000202820:	00078713          	mv	a4,a5
ffffffe000202824:	05800793          	li	a5,88
ffffffe000202828:	00f71e63          	bne	a4,a5,ffffffe000202844 <strtol+0x114>
                base = 16;
ffffffe00020282c:	01000793          	li	a5,16
ffffffe000202830:	faf42e23          	sw	a5,-68(s0)
                p++;
ffffffe000202834:	fd843783          	ld	a5,-40(s0)
ffffffe000202838:	00178793          	addi	a5,a5,1
ffffffe00020283c:	fcf43c23          	sd	a5,-40(s0)
ffffffe000202840:	0180006f          	j	ffffffe000202858 <strtol+0x128>
            } else {
                base = 8;
ffffffe000202844:	00800793          	li	a5,8
ffffffe000202848:	faf42e23          	sw	a5,-68(s0)
ffffffe00020284c:	00c0006f          	j	ffffffe000202858 <strtol+0x128>
            }
        } else {
            base = 10;
ffffffe000202850:	00a00793          	li	a5,10
ffffffe000202854:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
ffffffe000202858:	fd843783          	ld	a5,-40(s0)
ffffffe00020285c:	0007c783          	lbu	a5,0(a5)
ffffffe000202860:	00078713          	mv	a4,a5
ffffffe000202864:	02f00793          	li	a5,47
ffffffe000202868:	02e7f863          	bgeu	a5,a4,ffffffe000202898 <strtol+0x168>
ffffffe00020286c:	fd843783          	ld	a5,-40(s0)
ffffffe000202870:	0007c783          	lbu	a5,0(a5)
ffffffe000202874:	00078713          	mv	a4,a5
ffffffe000202878:	03900793          	li	a5,57
ffffffe00020287c:	00e7ee63          	bltu	a5,a4,ffffffe000202898 <strtol+0x168>
            digit = *p - '0';
ffffffe000202880:	fd843783          	ld	a5,-40(s0)
ffffffe000202884:	0007c783          	lbu	a5,0(a5)
ffffffe000202888:	0007879b          	sext.w	a5,a5
ffffffe00020288c:	fd07879b          	addiw	a5,a5,-48
ffffffe000202890:	fcf42a23          	sw	a5,-44(s0)
ffffffe000202894:	0800006f          	j	ffffffe000202914 <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
ffffffe000202898:	fd843783          	ld	a5,-40(s0)
ffffffe00020289c:	0007c783          	lbu	a5,0(a5)
ffffffe0002028a0:	00078713          	mv	a4,a5
ffffffe0002028a4:	06000793          	li	a5,96
ffffffe0002028a8:	02e7f863          	bgeu	a5,a4,ffffffe0002028d8 <strtol+0x1a8>
ffffffe0002028ac:	fd843783          	ld	a5,-40(s0)
ffffffe0002028b0:	0007c783          	lbu	a5,0(a5)
ffffffe0002028b4:	00078713          	mv	a4,a5
ffffffe0002028b8:	07a00793          	li	a5,122
ffffffe0002028bc:	00e7ee63          	bltu	a5,a4,ffffffe0002028d8 <strtol+0x1a8>
            digit = *p - ('a' - 10);
ffffffe0002028c0:	fd843783          	ld	a5,-40(s0)
ffffffe0002028c4:	0007c783          	lbu	a5,0(a5)
ffffffe0002028c8:	0007879b          	sext.w	a5,a5
ffffffe0002028cc:	fa97879b          	addiw	a5,a5,-87
ffffffe0002028d0:	fcf42a23          	sw	a5,-44(s0)
ffffffe0002028d4:	0400006f          	j	ffffffe000202914 <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
ffffffe0002028d8:	fd843783          	ld	a5,-40(s0)
ffffffe0002028dc:	0007c783          	lbu	a5,0(a5)
ffffffe0002028e0:	00078713          	mv	a4,a5
ffffffe0002028e4:	04000793          	li	a5,64
ffffffe0002028e8:	06e7f863          	bgeu	a5,a4,ffffffe000202958 <strtol+0x228>
ffffffe0002028ec:	fd843783          	ld	a5,-40(s0)
ffffffe0002028f0:	0007c783          	lbu	a5,0(a5)
ffffffe0002028f4:	00078713          	mv	a4,a5
ffffffe0002028f8:	05a00793          	li	a5,90
ffffffe0002028fc:	04e7ee63          	bltu	a5,a4,ffffffe000202958 <strtol+0x228>
            digit = *p - ('A' - 10);
ffffffe000202900:	fd843783          	ld	a5,-40(s0)
ffffffe000202904:	0007c783          	lbu	a5,0(a5)
ffffffe000202908:	0007879b          	sext.w	a5,a5
ffffffe00020290c:	fc97879b          	addiw	a5,a5,-55
ffffffe000202910:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
ffffffe000202914:	fd442783          	lw	a5,-44(s0)
ffffffe000202918:	00078713          	mv	a4,a5
ffffffe00020291c:	fbc42783          	lw	a5,-68(s0)
ffffffe000202920:	0007071b          	sext.w	a4,a4
ffffffe000202924:	0007879b          	sext.w	a5,a5
ffffffe000202928:	02f75663          	bge	a4,a5,ffffffe000202954 <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
ffffffe00020292c:	fbc42703          	lw	a4,-68(s0)
ffffffe000202930:	fe843783          	ld	a5,-24(s0)
ffffffe000202934:	02f70733          	mul	a4,a4,a5
ffffffe000202938:	fd442783          	lw	a5,-44(s0)
ffffffe00020293c:	00f707b3          	add	a5,a4,a5
ffffffe000202940:	fef43423          	sd	a5,-24(s0)
        p++;
ffffffe000202944:	fd843783          	ld	a5,-40(s0)
ffffffe000202948:	00178793          	addi	a5,a5,1
ffffffe00020294c:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
ffffffe000202950:	f09ff06f          	j	ffffffe000202858 <strtol+0x128>
            break;
ffffffe000202954:	00000013          	nop
    }

    if (endptr) {
ffffffe000202958:	fc043783          	ld	a5,-64(s0)
ffffffe00020295c:	00078863          	beqz	a5,ffffffe00020296c <strtol+0x23c>
        *endptr = (char *)p;
ffffffe000202960:	fc043783          	ld	a5,-64(s0)
ffffffe000202964:	fd843703          	ld	a4,-40(s0)
ffffffe000202968:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
ffffffe00020296c:	fe744783          	lbu	a5,-25(s0)
ffffffe000202970:	0ff7f793          	zext.b	a5,a5
ffffffe000202974:	00078863          	beqz	a5,ffffffe000202984 <strtol+0x254>
ffffffe000202978:	fe843783          	ld	a5,-24(s0)
ffffffe00020297c:	40f007b3          	neg	a5,a5
ffffffe000202980:	0080006f          	j	ffffffe000202988 <strtol+0x258>
ffffffe000202984:	fe843783          	ld	a5,-24(s0)
}
ffffffe000202988:	00078513          	mv	a0,a5
ffffffe00020298c:	04813083          	ld	ra,72(sp)
ffffffe000202990:	04013403          	ld	s0,64(sp)
ffffffe000202994:	05010113          	addi	sp,sp,80
ffffffe000202998:	00008067          	ret

ffffffe00020299c <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
ffffffe00020299c:	fd010113          	addi	sp,sp,-48
ffffffe0002029a0:	02113423          	sd	ra,40(sp)
ffffffe0002029a4:	02813023          	sd	s0,32(sp)
ffffffe0002029a8:	03010413          	addi	s0,sp,48
ffffffe0002029ac:	fca43c23          	sd	a0,-40(s0)
ffffffe0002029b0:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
ffffffe0002029b4:	fd043783          	ld	a5,-48(s0)
ffffffe0002029b8:	00079863          	bnez	a5,ffffffe0002029c8 <puts_wo_nl+0x2c>
        s = "(null)";
ffffffe0002029bc:	00002797          	auipc	a5,0x2
ffffffe0002029c0:	af478793          	addi	a5,a5,-1292 # ffffffe0002044b0 <__func__.0+0x40>
ffffffe0002029c4:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
ffffffe0002029c8:	fd043783          	ld	a5,-48(s0)
ffffffe0002029cc:	fef43423          	sd	a5,-24(s0)
    while (*p) {
ffffffe0002029d0:	0240006f          	j	ffffffe0002029f4 <puts_wo_nl+0x58>
        putch(*p++);
ffffffe0002029d4:	fe843783          	ld	a5,-24(s0)
ffffffe0002029d8:	00178713          	addi	a4,a5,1
ffffffe0002029dc:	fee43423          	sd	a4,-24(s0)
ffffffe0002029e0:	0007c783          	lbu	a5,0(a5)
ffffffe0002029e4:	0007871b          	sext.w	a4,a5
ffffffe0002029e8:	fd843783          	ld	a5,-40(s0)
ffffffe0002029ec:	00070513          	mv	a0,a4
ffffffe0002029f0:	000780e7          	jalr	a5
    while (*p) {
ffffffe0002029f4:	fe843783          	ld	a5,-24(s0)
ffffffe0002029f8:	0007c783          	lbu	a5,0(a5)
ffffffe0002029fc:	fc079ce3          	bnez	a5,ffffffe0002029d4 <puts_wo_nl+0x38>
    }
    return p - s;
ffffffe000202a00:	fe843703          	ld	a4,-24(s0)
ffffffe000202a04:	fd043783          	ld	a5,-48(s0)
ffffffe000202a08:	40f707b3          	sub	a5,a4,a5
ffffffe000202a0c:	0007879b          	sext.w	a5,a5
}
ffffffe000202a10:	00078513          	mv	a0,a5
ffffffe000202a14:	02813083          	ld	ra,40(sp)
ffffffe000202a18:	02013403          	ld	s0,32(sp)
ffffffe000202a1c:	03010113          	addi	sp,sp,48
ffffffe000202a20:	00008067          	ret

ffffffe000202a24 <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
ffffffe000202a24:	f9010113          	addi	sp,sp,-112
ffffffe000202a28:	06113423          	sd	ra,104(sp)
ffffffe000202a2c:	06813023          	sd	s0,96(sp)
ffffffe000202a30:	07010413          	addi	s0,sp,112
ffffffe000202a34:	faa43423          	sd	a0,-88(s0)
ffffffe000202a38:	fab43023          	sd	a1,-96(s0)
ffffffe000202a3c:	00060793          	mv	a5,a2
ffffffe000202a40:	f8d43823          	sd	a3,-112(s0)
ffffffe000202a44:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
ffffffe000202a48:	f9f44783          	lbu	a5,-97(s0)
ffffffe000202a4c:	0ff7f793          	zext.b	a5,a5
ffffffe000202a50:	02078663          	beqz	a5,ffffffe000202a7c <print_dec_int+0x58>
ffffffe000202a54:	fa043703          	ld	a4,-96(s0)
ffffffe000202a58:	fff00793          	li	a5,-1
ffffffe000202a5c:	03f79793          	slli	a5,a5,0x3f
ffffffe000202a60:	00f71e63          	bne	a4,a5,ffffffe000202a7c <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
ffffffe000202a64:	00002597          	auipc	a1,0x2
ffffffe000202a68:	a5458593          	addi	a1,a1,-1452 # ffffffe0002044b8 <__func__.0+0x48>
ffffffe000202a6c:	fa843503          	ld	a0,-88(s0)
ffffffe000202a70:	f2dff0ef          	jal	ffffffe00020299c <puts_wo_nl>
ffffffe000202a74:	00050793          	mv	a5,a0
ffffffe000202a78:	2a00006f          	j	ffffffe000202d18 <print_dec_int+0x2f4>
    }

    if (flags->prec == 0 && num == 0) {
ffffffe000202a7c:	f9043783          	ld	a5,-112(s0)
ffffffe000202a80:	00c7a783          	lw	a5,12(a5)
ffffffe000202a84:	00079a63          	bnez	a5,ffffffe000202a98 <print_dec_int+0x74>
ffffffe000202a88:	fa043783          	ld	a5,-96(s0)
ffffffe000202a8c:	00079663          	bnez	a5,ffffffe000202a98 <print_dec_int+0x74>
        return 0;
ffffffe000202a90:	00000793          	li	a5,0
ffffffe000202a94:	2840006f          	j	ffffffe000202d18 <print_dec_int+0x2f4>
    }

    bool neg = false;
ffffffe000202a98:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
ffffffe000202a9c:	f9f44783          	lbu	a5,-97(s0)
ffffffe000202aa0:	0ff7f793          	zext.b	a5,a5
ffffffe000202aa4:	02078063          	beqz	a5,ffffffe000202ac4 <print_dec_int+0xa0>
ffffffe000202aa8:	fa043783          	ld	a5,-96(s0)
ffffffe000202aac:	0007dc63          	bgez	a5,ffffffe000202ac4 <print_dec_int+0xa0>
        neg = true;
ffffffe000202ab0:	00100793          	li	a5,1
ffffffe000202ab4:	fef407a3          	sb	a5,-17(s0)
        num = -num;
ffffffe000202ab8:	fa043783          	ld	a5,-96(s0)
ffffffe000202abc:	40f007b3          	neg	a5,a5
ffffffe000202ac0:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
ffffffe000202ac4:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
ffffffe000202ac8:	f9f44783          	lbu	a5,-97(s0)
ffffffe000202acc:	0ff7f793          	zext.b	a5,a5
ffffffe000202ad0:	02078863          	beqz	a5,ffffffe000202b00 <print_dec_int+0xdc>
ffffffe000202ad4:	fef44783          	lbu	a5,-17(s0)
ffffffe000202ad8:	0ff7f793          	zext.b	a5,a5
ffffffe000202adc:	00079e63          	bnez	a5,ffffffe000202af8 <print_dec_int+0xd4>
ffffffe000202ae0:	f9043783          	ld	a5,-112(s0)
ffffffe000202ae4:	0057c783          	lbu	a5,5(a5)
ffffffe000202ae8:	00079863          	bnez	a5,ffffffe000202af8 <print_dec_int+0xd4>
ffffffe000202aec:	f9043783          	ld	a5,-112(s0)
ffffffe000202af0:	0047c783          	lbu	a5,4(a5)
ffffffe000202af4:	00078663          	beqz	a5,ffffffe000202b00 <print_dec_int+0xdc>
ffffffe000202af8:	00100793          	li	a5,1
ffffffe000202afc:	0080006f          	j	ffffffe000202b04 <print_dec_int+0xe0>
ffffffe000202b00:	00000793          	li	a5,0
ffffffe000202b04:	fcf40ba3          	sb	a5,-41(s0)
ffffffe000202b08:	fd744783          	lbu	a5,-41(s0)
ffffffe000202b0c:	0017f793          	andi	a5,a5,1
ffffffe000202b10:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
ffffffe000202b14:	fa043703          	ld	a4,-96(s0)
ffffffe000202b18:	00a00793          	li	a5,10
ffffffe000202b1c:	02f777b3          	remu	a5,a4,a5
ffffffe000202b20:	0ff7f713          	zext.b	a4,a5
ffffffe000202b24:	fe842783          	lw	a5,-24(s0)
ffffffe000202b28:	0017869b          	addiw	a3,a5,1
ffffffe000202b2c:	fed42423          	sw	a3,-24(s0)
ffffffe000202b30:	0307071b          	addiw	a4,a4,48
ffffffe000202b34:	0ff77713          	zext.b	a4,a4
ffffffe000202b38:	ff078793          	addi	a5,a5,-16
ffffffe000202b3c:	008787b3          	add	a5,a5,s0
ffffffe000202b40:	fce78423          	sb	a4,-56(a5)
        num /= 10;
ffffffe000202b44:	fa043703          	ld	a4,-96(s0)
ffffffe000202b48:	00a00793          	li	a5,10
ffffffe000202b4c:	02f757b3          	divu	a5,a4,a5
ffffffe000202b50:	faf43023          	sd	a5,-96(s0)
    } while (num);
ffffffe000202b54:	fa043783          	ld	a5,-96(s0)
ffffffe000202b58:	fa079ee3          	bnez	a5,ffffffe000202b14 <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
ffffffe000202b5c:	f9043783          	ld	a5,-112(s0)
ffffffe000202b60:	00c7a783          	lw	a5,12(a5)
ffffffe000202b64:	00078713          	mv	a4,a5
ffffffe000202b68:	fff00793          	li	a5,-1
ffffffe000202b6c:	02f71063          	bne	a4,a5,ffffffe000202b8c <print_dec_int+0x168>
ffffffe000202b70:	f9043783          	ld	a5,-112(s0)
ffffffe000202b74:	0037c783          	lbu	a5,3(a5)
ffffffe000202b78:	00078a63          	beqz	a5,ffffffe000202b8c <print_dec_int+0x168>
        flags->prec = flags->width;
ffffffe000202b7c:	f9043783          	ld	a5,-112(s0)
ffffffe000202b80:	0087a703          	lw	a4,8(a5)
ffffffe000202b84:	f9043783          	ld	a5,-112(s0)
ffffffe000202b88:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
ffffffe000202b8c:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe000202b90:	f9043783          	ld	a5,-112(s0)
ffffffe000202b94:	0087a703          	lw	a4,8(a5)
ffffffe000202b98:	fe842783          	lw	a5,-24(s0)
ffffffe000202b9c:	fcf42823          	sw	a5,-48(s0)
ffffffe000202ba0:	f9043783          	ld	a5,-112(s0)
ffffffe000202ba4:	00c7a783          	lw	a5,12(a5)
ffffffe000202ba8:	fcf42623          	sw	a5,-52(s0)
ffffffe000202bac:	fd042783          	lw	a5,-48(s0)
ffffffe000202bb0:	00078593          	mv	a1,a5
ffffffe000202bb4:	fcc42783          	lw	a5,-52(s0)
ffffffe000202bb8:	00078613          	mv	a2,a5
ffffffe000202bbc:	0006069b          	sext.w	a3,a2
ffffffe000202bc0:	0005879b          	sext.w	a5,a1
ffffffe000202bc4:	00f6d463          	bge	a3,a5,ffffffe000202bcc <print_dec_int+0x1a8>
ffffffe000202bc8:	00058613          	mv	a2,a1
ffffffe000202bcc:	0006079b          	sext.w	a5,a2
ffffffe000202bd0:	40f707bb          	subw	a5,a4,a5
ffffffe000202bd4:	0007871b          	sext.w	a4,a5
ffffffe000202bd8:	fd744783          	lbu	a5,-41(s0)
ffffffe000202bdc:	0007879b          	sext.w	a5,a5
ffffffe000202be0:	40f707bb          	subw	a5,a4,a5
ffffffe000202be4:	fef42023          	sw	a5,-32(s0)
ffffffe000202be8:	0280006f          	j	ffffffe000202c10 <print_dec_int+0x1ec>
        putch(' ');
ffffffe000202bec:	fa843783          	ld	a5,-88(s0)
ffffffe000202bf0:	02000513          	li	a0,32
ffffffe000202bf4:	000780e7          	jalr	a5
        ++written;
ffffffe000202bf8:	fe442783          	lw	a5,-28(s0)
ffffffe000202bfc:	0017879b          	addiw	a5,a5,1
ffffffe000202c00:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe000202c04:	fe042783          	lw	a5,-32(s0)
ffffffe000202c08:	fff7879b          	addiw	a5,a5,-1
ffffffe000202c0c:	fef42023          	sw	a5,-32(s0)
ffffffe000202c10:	fe042783          	lw	a5,-32(s0)
ffffffe000202c14:	0007879b          	sext.w	a5,a5
ffffffe000202c18:	fcf04ae3          	bgtz	a5,ffffffe000202bec <print_dec_int+0x1c8>
    }

    if (has_sign_char) {
ffffffe000202c1c:	fd744783          	lbu	a5,-41(s0)
ffffffe000202c20:	0ff7f793          	zext.b	a5,a5
ffffffe000202c24:	04078463          	beqz	a5,ffffffe000202c6c <print_dec_int+0x248>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
ffffffe000202c28:	fef44783          	lbu	a5,-17(s0)
ffffffe000202c2c:	0ff7f793          	zext.b	a5,a5
ffffffe000202c30:	00078663          	beqz	a5,ffffffe000202c3c <print_dec_int+0x218>
ffffffe000202c34:	02d00793          	li	a5,45
ffffffe000202c38:	01c0006f          	j	ffffffe000202c54 <print_dec_int+0x230>
ffffffe000202c3c:	f9043783          	ld	a5,-112(s0)
ffffffe000202c40:	0057c783          	lbu	a5,5(a5)
ffffffe000202c44:	00078663          	beqz	a5,ffffffe000202c50 <print_dec_int+0x22c>
ffffffe000202c48:	02b00793          	li	a5,43
ffffffe000202c4c:	0080006f          	j	ffffffe000202c54 <print_dec_int+0x230>
ffffffe000202c50:	02000793          	li	a5,32
ffffffe000202c54:	fa843703          	ld	a4,-88(s0)
ffffffe000202c58:	00078513          	mv	a0,a5
ffffffe000202c5c:	000700e7          	jalr	a4
        ++written;
ffffffe000202c60:	fe442783          	lw	a5,-28(s0)
ffffffe000202c64:	0017879b          	addiw	a5,a5,1
ffffffe000202c68:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe000202c6c:	fe842783          	lw	a5,-24(s0)
ffffffe000202c70:	fcf42e23          	sw	a5,-36(s0)
ffffffe000202c74:	0280006f          	j	ffffffe000202c9c <print_dec_int+0x278>
        putch('0');
ffffffe000202c78:	fa843783          	ld	a5,-88(s0)
ffffffe000202c7c:	03000513          	li	a0,48
ffffffe000202c80:	000780e7          	jalr	a5
        ++written;
ffffffe000202c84:	fe442783          	lw	a5,-28(s0)
ffffffe000202c88:	0017879b          	addiw	a5,a5,1
ffffffe000202c8c:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe000202c90:	fdc42783          	lw	a5,-36(s0)
ffffffe000202c94:	0017879b          	addiw	a5,a5,1
ffffffe000202c98:	fcf42e23          	sw	a5,-36(s0)
ffffffe000202c9c:	f9043783          	ld	a5,-112(s0)
ffffffe000202ca0:	00c7a703          	lw	a4,12(a5)
ffffffe000202ca4:	fd744783          	lbu	a5,-41(s0)
ffffffe000202ca8:	0007879b          	sext.w	a5,a5
ffffffe000202cac:	40f707bb          	subw	a5,a4,a5
ffffffe000202cb0:	0007871b          	sext.w	a4,a5
ffffffe000202cb4:	fdc42783          	lw	a5,-36(s0)
ffffffe000202cb8:	0007879b          	sext.w	a5,a5
ffffffe000202cbc:	fae7cee3          	blt	a5,a4,ffffffe000202c78 <print_dec_int+0x254>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe000202cc0:	fe842783          	lw	a5,-24(s0)
ffffffe000202cc4:	fff7879b          	addiw	a5,a5,-1
ffffffe000202cc8:	fcf42c23          	sw	a5,-40(s0)
ffffffe000202ccc:	03c0006f          	j	ffffffe000202d08 <print_dec_int+0x2e4>
        putch(buf[i]);
ffffffe000202cd0:	fd842783          	lw	a5,-40(s0)
ffffffe000202cd4:	ff078793          	addi	a5,a5,-16
ffffffe000202cd8:	008787b3          	add	a5,a5,s0
ffffffe000202cdc:	fc87c783          	lbu	a5,-56(a5)
ffffffe000202ce0:	0007871b          	sext.w	a4,a5
ffffffe000202ce4:	fa843783          	ld	a5,-88(s0)
ffffffe000202ce8:	00070513          	mv	a0,a4
ffffffe000202cec:	000780e7          	jalr	a5
        ++written;
ffffffe000202cf0:	fe442783          	lw	a5,-28(s0)
ffffffe000202cf4:	0017879b          	addiw	a5,a5,1
ffffffe000202cf8:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe000202cfc:	fd842783          	lw	a5,-40(s0)
ffffffe000202d00:	fff7879b          	addiw	a5,a5,-1
ffffffe000202d04:	fcf42c23          	sw	a5,-40(s0)
ffffffe000202d08:	fd842783          	lw	a5,-40(s0)
ffffffe000202d0c:	0007879b          	sext.w	a5,a5
ffffffe000202d10:	fc07d0e3          	bgez	a5,ffffffe000202cd0 <print_dec_int+0x2ac>
    }

    return written;
ffffffe000202d14:	fe442783          	lw	a5,-28(s0)
}
ffffffe000202d18:	00078513          	mv	a0,a5
ffffffe000202d1c:	06813083          	ld	ra,104(sp)
ffffffe000202d20:	06013403          	ld	s0,96(sp)
ffffffe000202d24:	07010113          	addi	sp,sp,112
ffffffe000202d28:	00008067          	ret

ffffffe000202d2c <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
ffffffe000202d2c:	f4010113          	addi	sp,sp,-192
ffffffe000202d30:	0a113c23          	sd	ra,184(sp)
ffffffe000202d34:	0a813823          	sd	s0,176(sp)
ffffffe000202d38:	0c010413          	addi	s0,sp,192
ffffffe000202d3c:	f4a43c23          	sd	a0,-168(s0)
ffffffe000202d40:	f4b43823          	sd	a1,-176(s0)
ffffffe000202d44:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
ffffffe000202d48:	f8043023          	sd	zero,-128(s0)
ffffffe000202d4c:	f8043423          	sd	zero,-120(s0)

    int written = 0;
ffffffe000202d50:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
ffffffe000202d54:	7a40006f          	j	ffffffe0002034f8 <vprintfmt+0x7cc>
        if (flags.in_format) {
ffffffe000202d58:	f8044783          	lbu	a5,-128(s0)
ffffffe000202d5c:	72078e63          	beqz	a5,ffffffe000203498 <vprintfmt+0x76c>
            if (*fmt == '#') {
ffffffe000202d60:	f5043783          	ld	a5,-176(s0)
ffffffe000202d64:	0007c783          	lbu	a5,0(a5)
ffffffe000202d68:	00078713          	mv	a4,a5
ffffffe000202d6c:	02300793          	li	a5,35
ffffffe000202d70:	00f71863          	bne	a4,a5,ffffffe000202d80 <vprintfmt+0x54>
                flags.sharpflag = true;
ffffffe000202d74:	00100793          	li	a5,1
ffffffe000202d78:	f8f40123          	sb	a5,-126(s0)
ffffffe000202d7c:	7700006f          	j	ffffffe0002034ec <vprintfmt+0x7c0>
            } else if (*fmt == '0') {
ffffffe000202d80:	f5043783          	ld	a5,-176(s0)
ffffffe000202d84:	0007c783          	lbu	a5,0(a5)
ffffffe000202d88:	00078713          	mv	a4,a5
ffffffe000202d8c:	03000793          	li	a5,48
ffffffe000202d90:	00f71863          	bne	a4,a5,ffffffe000202da0 <vprintfmt+0x74>
                flags.zeroflag = true;
ffffffe000202d94:	00100793          	li	a5,1
ffffffe000202d98:	f8f401a3          	sb	a5,-125(s0)
ffffffe000202d9c:	7500006f          	j	ffffffe0002034ec <vprintfmt+0x7c0>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
ffffffe000202da0:	f5043783          	ld	a5,-176(s0)
ffffffe000202da4:	0007c783          	lbu	a5,0(a5)
ffffffe000202da8:	00078713          	mv	a4,a5
ffffffe000202dac:	06c00793          	li	a5,108
ffffffe000202db0:	04f70063          	beq	a4,a5,ffffffe000202df0 <vprintfmt+0xc4>
ffffffe000202db4:	f5043783          	ld	a5,-176(s0)
ffffffe000202db8:	0007c783          	lbu	a5,0(a5)
ffffffe000202dbc:	00078713          	mv	a4,a5
ffffffe000202dc0:	07a00793          	li	a5,122
ffffffe000202dc4:	02f70663          	beq	a4,a5,ffffffe000202df0 <vprintfmt+0xc4>
ffffffe000202dc8:	f5043783          	ld	a5,-176(s0)
ffffffe000202dcc:	0007c783          	lbu	a5,0(a5)
ffffffe000202dd0:	00078713          	mv	a4,a5
ffffffe000202dd4:	07400793          	li	a5,116
ffffffe000202dd8:	00f70c63          	beq	a4,a5,ffffffe000202df0 <vprintfmt+0xc4>
ffffffe000202ddc:	f5043783          	ld	a5,-176(s0)
ffffffe000202de0:	0007c783          	lbu	a5,0(a5)
ffffffe000202de4:	00078713          	mv	a4,a5
ffffffe000202de8:	06a00793          	li	a5,106
ffffffe000202dec:	00f71863          	bne	a4,a5,ffffffe000202dfc <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
ffffffe000202df0:	00100793          	li	a5,1
ffffffe000202df4:	f8f400a3          	sb	a5,-127(s0)
ffffffe000202df8:	6f40006f          	j	ffffffe0002034ec <vprintfmt+0x7c0>
            } else if (*fmt == '+') {
ffffffe000202dfc:	f5043783          	ld	a5,-176(s0)
ffffffe000202e00:	0007c783          	lbu	a5,0(a5)
ffffffe000202e04:	00078713          	mv	a4,a5
ffffffe000202e08:	02b00793          	li	a5,43
ffffffe000202e0c:	00f71863          	bne	a4,a5,ffffffe000202e1c <vprintfmt+0xf0>
                flags.sign = true;
ffffffe000202e10:	00100793          	li	a5,1
ffffffe000202e14:	f8f402a3          	sb	a5,-123(s0)
ffffffe000202e18:	6d40006f          	j	ffffffe0002034ec <vprintfmt+0x7c0>
            } else if (*fmt == ' ') {
ffffffe000202e1c:	f5043783          	ld	a5,-176(s0)
ffffffe000202e20:	0007c783          	lbu	a5,0(a5)
ffffffe000202e24:	00078713          	mv	a4,a5
ffffffe000202e28:	02000793          	li	a5,32
ffffffe000202e2c:	00f71863          	bne	a4,a5,ffffffe000202e3c <vprintfmt+0x110>
                flags.spaceflag = true;
ffffffe000202e30:	00100793          	li	a5,1
ffffffe000202e34:	f8f40223          	sb	a5,-124(s0)
ffffffe000202e38:	6b40006f          	j	ffffffe0002034ec <vprintfmt+0x7c0>
            } else if (*fmt == '*') {
ffffffe000202e3c:	f5043783          	ld	a5,-176(s0)
ffffffe000202e40:	0007c783          	lbu	a5,0(a5)
ffffffe000202e44:	00078713          	mv	a4,a5
ffffffe000202e48:	02a00793          	li	a5,42
ffffffe000202e4c:	00f71e63          	bne	a4,a5,ffffffe000202e68 <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
ffffffe000202e50:	f4843783          	ld	a5,-184(s0)
ffffffe000202e54:	00878713          	addi	a4,a5,8
ffffffe000202e58:	f4e43423          	sd	a4,-184(s0)
ffffffe000202e5c:	0007a783          	lw	a5,0(a5)
ffffffe000202e60:	f8f42423          	sw	a5,-120(s0)
ffffffe000202e64:	6880006f          	j	ffffffe0002034ec <vprintfmt+0x7c0>
            } else if (*fmt >= '1' && *fmt <= '9') {
ffffffe000202e68:	f5043783          	ld	a5,-176(s0)
ffffffe000202e6c:	0007c783          	lbu	a5,0(a5)
ffffffe000202e70:	00078713          	mv	a4,a5
ffffffe000202e74:	03000793          	li	a5,48
ffffffe000202e78:	04e7f663          	bgeu	a5,a4,ffffffe000202ec4 <vprintfmt+0x198>
ffffffe000202e7c:	f5043783          	ld	a5,-176(s0)
ffffffe000202e80:	0007c783          	lbu	a5,0(a5)
ffffffe000202e84:	00078713          	mv	a4,a5
ffffffe000202e88:	03900793          	li	a5,57
ffffffe000202e8c:	02e7ec63          	bltu	a5,a4,ffffffe000202ec4 <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
ffffffe000202e90:	f5043783          	ld	a5,-176(s0)
ffffffe000202e94:	f5040713          	addi	a4,s0,-176
ffffffe000202e98:	00a00613          	li	a2,10
ffffffe000202e9c:	00070593          	mv	a1,a4
ffffffe000202ea0:	00078513          	mv	a0,a5
ffffffe000202ea4:	88dff0ef          	jal	ffffffe000202730 <strtol>
ffffffe000202ea8:	00050793          	mv	a5,a0
ffffffe000202eac:	0007879b          	sext.w	a5,a5
ffffffe000202eb0:	f8f42423          	sw	a5,-120(s0)
                fmt--;
ffffffe000202eb4:	f5043783          	ld	a5,-176(s0)
ffffffe000202eb8:	fff78793          	addi	a5,a5,-1
ffffffe000202ebc:	f4f43823          	sd	a5,-176(s0)
ffffffe000202ec0:	62c0006f          	j	ffffffe0002034ec <vprintfmt+0x7c0>
            } else if (*fmt == '.') {
ffffffe000202ec4:	f5043783          	ld	a5,-176(s0)
ffffffe000202ec8:	0007c783          	lbu	a5,0(a5)
ffffffe000202ecc:	00078713          	mv	a4,a5
ffffffe000202ed0:	02e00793          	li	a5,46
ffffffe000202ed4:	06f71863          	bne	a4,a5,ffffffe000202f44 <vprintfmt+0x218>
                fmt++;
ffffffe000202ed8:	f5043783          	ld	a5,-176(s0)
ffffffe000202edc:	00178793          	addi	a5,a5,1
ffffffe000202ee0:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
ffffffe000202ee4:	f5043783          	ld	a5,-176(s0)
ffffffe000202ee8:	0007c783          	lbu	a5,0(a5)
ffffffe000202eec:	00078713          	mv	a4,a5
ffffffe000202ef0:	02a00793          	li	a5,42
ffffffe000202ef4:	00f71e63          	bne	a4,a5,ffffffe000202f10 <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
ffffffe000202ef8:	f4843783          	ld	a5,-184(s0)
ffffffe000202efc:	00878713          	addi	a4,a5,8
ffffffe000202f00:	f4e43423          	sd	a4,-184(s0)
ffffffe000202f04:	0007a783          	lw	a5,0(a5)
ffffffe000202f08:	f8f42623          	sw	a5,-116(s0)
ffffffe000202f0c:	5e00006f          	j	ffffffe0002034ec <vprintfmt+0x7c0>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
ffffffe000202f10:	f5043783          	ld	a5,-176(s0)
ffffffe000202f14:	f5040713          	addi	a4,s0,-176
ffffffe000202f18:	00a00613          	li	a2,10
ffffffe000202f1c:	00070593          	mv	a1,a4
ffffffe000202f20:	00078513          	mv	a0,a5
ffffffe000202f24:	80dff0ef          	jal	ffffffe000202730 <strtol>
ffffffe000202f28:	00050793          	mv	a5,a0
ffffffe000202f2c:	0007879b          	sext.w	a5,a5
ffffffe000202f30:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
ffffffe000202f34:	f5043783          	ld	a5,-176(s0)
ffffffe000202f38:	fff78793          	addi	a5,a5,-1
ffffffe000202f3c:	f4f43823          	sd	a5,-176(s0)
ffffffe000202f40:	5ac0006f          	j	ffffffe0002034ec <vprintfmt+0x7c0>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe000202f44:	f5043783          	ld	a5,-176(s0)
ffffffe000202f48:	0007c783          	lbu	a5,0(a5)
ffffffe000202f4c:	00078713          	mv	a4,a5
ffffffe000202f50:	07800793          	li	a5,120
ffffffe000202f54:	02f70663          	beq	a4,a5,ffffffe000202f80 <vprintfmt+0x254>
ffffffe000202f58:	f5043783          	ld	a5,-176(s0)
ffffffe000202f5c:	0007c783          	lbu	a5,0(a5)
ffffffe000202f60:	00078713          	mv	a4,a5
ffffffe000202f64:	05800793          	li	a5,88
ffffffe000202f68:	00f70c63          	beq	a4,a5,ffffffe000202f80 <vprintfmt+0x254>
ffffffe000202f6c:	f5043783          	ld	a5,-176(s0)
ffffffe000202f70:	0007c783          	lbu	a5,0(a5)
ffffffe000202f74:	00078713          	mv	a4,a5
ffffffe000202f78:	07000793          	li	a5,112
ffffffe000202f7c:	30f71263          	bne	a4,a5,ffffffe000203280 <vprintfmt+0x554>
                bool is_long = *fmt == 'p' || flags.longflag;
ffffffe000202f80:	f5043783          	ld	a5,-176(s0)
ffffffe000202f84:	0007c783          	lbu	a5,0(a5)
ffffffe000202f88:	00078713          	mv	a4,a5
ffffffe000202f8c:	07000793          	li	a5,112
ffffffe000202f90:	00f70663          	beq	a4,a5,ffffffe000202f9c <vprintfmt+0x270>
ffffffe000202f94:	f8144783          	lbu	a5,-127(s0)
ffffffe000202f98:	00078663          	beqz	a5,ffffffe000202fa4 <vprintfmt+0x278>
ffffffe000202f9c:	00100793          	li	a5,1
ffffffe000202fa0:	0080006f          	j	ffffffe000202fa8 <vprintfmt+0x27c>
ffffffe000202fa4:	00000793          	li	a5,0
ffffffe000202fa8:	faf403a3          	sb	a5,-89(s0)
ffffffe000202fac:	fa744783          	lbu	a5,-89(s0)
ffffffe000202fb0:	0017f793          	andi	a5,a5,1
ffffffe000202fb4:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
ffffffe000202fb8:	fa744783          	lbu	a5,-89(s0)
ffffffe000202fbc:	0ff7f793          	zext.b	a5,a5
ffffffe000202fc0:	00078c63          	beqz	a5,ffffffe000202fd8 <vprintfmt+0x2ac>
ffffffe000202fc4:	f4843783          	ld	a5,-184(s0)
ffffffe000202fc8:	00878713          	addi	a4,a5,8
ffffffe000202fcc:	f4e43423          	sd	a4,-184(s0)
ffffffe000202fd0:	0007b783          	ld	a5,0(a5)
ffffffe000202fd4:	01c0006f          	j	ffffffe000202ff0 <vprintfmt+0x2c4>
ffffffe000202fd8:	f4843783          	ld	a5,-184(s0)
ffffffe000202fdc:	00878713          	addi	a4,a5,8
ffffffe000202fe0:	f4e43423          	sd	a4,-184(s0)
ffffffe000202fe4:	0007a783          	lw	a5,0(a5)
ffffffe000202fe8:	02079793          	slli	a5,a5,0x20
ffffffe000202fec:	0207d793          	srli	a5,a5,0x20
ffffffe000202ff0:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
ffffffe000202ff4:	f8c42783          	lw	a5,-116(s0)
ffffffe000202ff8:	02079463          	bnez	a5,ffffffe000203020 <vprintfmt+0x2f4>
ffffffe000202ffc:	fe043783          	ld	a5,-32(s0)
ffffffe000203000:	02079063          	bnez	a5,ffffffe000203020 <vprintfmt+0x2f4>
ffffffe000203004:	f5043783          	ld	a5,-176(s0)
ffffffe000203008:	0007c783          	lbu	a5,0(a5)
ffffffe00020300c:	00078713          	mv	a4,a5
ffffffe000203010:	07000793          	li	a5,112
ffffffe000203014:	00f70663          	beq	a4,a5,ffffffe000203020 <vprintfmt+0x2f4>
                    flags.in_format = false;
ffffffe000203018:	f8040023          	sb	zero,-128(s0)
ffffffe00020301c:	4d00006f          	j	ffffffe0002034ec <vprintfmt+0x7c0>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
ffffffe000203020:	f5043783          	ld	a5,-176(s0)
ffffffe000203024:	0007c783          	lbu	a5,0(a5)
ffffffe000203028:	00078713          	mv	a4,a5
ffffffe00020302c:	07000793          	li	a5,112
ffffffe000203030:	00f70a63          	beq	a4,a5,ffffffe000203044 <vprintfmt+0x318>
ffffffe000203034:	f8244783          	lbu	a5,-126(s0)
ffffffe000203038:	00078a63          	beqz	a5,ffffffe00020304c <vprintfmt+0x320>
ffffffe00020303c:	fe043783          	ld	a5,-32(s0)
ffffffe000203040:	00078663          	beqz	a5,ffffffe00020304c <vprintfmt+0x320>
ffffffe000203044:	00100793          	li	a5,1
ffffffe000203048:	0080006f          	j	ffffffe000203050 <vprintfmt+0x324>
ffffffe00020304c:	00000793          	li	a5,0
ffffffe000203050:	faf40323          	sb	a5,-90(s0)
ffffffe000203054:	fa644783          	lbu	a5,-90(s0)
ffffffe000203058:	0017f793          	andi	a5,a5,1
ffffffe00020305c:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
ffffffe000203060:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
ffffffe000203064:	f5043783          	ld	a5,-176(s0)
ffffffe000203068:	0007c783          	lbu	a5,0(a5)
ffffffe00020306c:	00078713          	mv	a4,a5
ffffffe000203070:	05800793          	li	a5,88
ffffffe000203074:	00f71863          	bne	a4,a5,ffffffe000203084 <vprintfmt+0x358>
ffffffe000203078:	00001797          	auipc	a5,0x1
ffffffe00020307c:	45878793          	addi	a5,a5,1112 # ffffffe0002044d0 <upperxdigits.1>
ffffffe000203080:	00c0006f          	j	ffffffe00020308c <vprintfmt+0x360>
ffffffe000203084:	00001797          	auipc	a5,0x1
ffffffe000203088:	46478793          	addi	a5,a5,1124 # ffffffe0002044e8 <lowerxdigits.0>
ffffffe00020308c:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
ffffffe000203090:	fe043783          	ld	a5,-32(s0)
ffffffe000203094:	00f7f793          	andi	a5,a5,15
ffffffe000203098:	f9843703          	ld	a4,-104(s0)
ffffffe00020309c:	00f70733          	add	a4,a4,a5
ffffffe0002030a0:	fdc42783          	lw	a5,-36(s0)
ffffffe0002030a4:	0017869b          	addiw	a3,a5,1
ffffffe0002030a8:	fcd42e23          	sw	a3,-36(s0)
ffffffe0002030ac:	00074703          	lbu	a4,0(a4)
ffffffe0002030b0:	ff078793          	addi	a5,a5,-16
ffffffe0002030b4:	008787b3          	add	a5,a5,s0
ffffffe0002030b8:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
ffffffe0002030bc:	fe043783          	ld	a5,-32(s0)
ffffffe0002030c0:	0047d793          	srli	a5,a5,0x4
ffffffe0002030c4:	fef43023          	sd	a5,-32(s0)
                } while (num);
ffffffe0002030c8:	fe043783          	ld	a5,-32(s0)
ffffffe0002030cc:	fc0792e3          	bnez	a5,ffffffe000203090 <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
ffffffe0002030d0:	f8c42783          	lw	a5,-116(s0)
ffffffe0002030d4:	00078713          	mv	a4,a5
ffffffe0002030d8:	fff00793          	li	a5,-1
ffffffe0002030dc:	02f71663          	bne	a4,a5,ffffffe000203108 <vprintfmt+0x3dc>
ffffffe0002030e0:	f8344783          	lbu	a5,-125(s0)
ffffffe0002030e4:	02078263          	beqz	a5,ffffffe000203108 <vprintfmt+0x3dc>
                    flags.prec = flags.width - 2 * prefix;
ffffffe0002030e8:	f8842703          	lw	a4,-120(s0)
ffffffe0002030ec:	fa644783          	lbu	a5,-90(s0)
ffffffe0002030f0:	0007879b          	sext.w	a5,a5
ffffffe0002030f4:	0017979b          	slliw	a5,a5,0x1
ffffffe0002030f8:	0007879b          	sext.w	a5,a5
ffffffe0002030fc:	40f707bb          	subw	a5,a4,a5
ffffffe000203100:	0007879b          	sext.w	a5,a5
ffffffe000203104:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe000203108:	f8842703          	lw	a4,-120(s0)
ffffffe00020310c:	fa644783          	lbu	a5,-90(s0)
ffffffe000203110:	0007879b          	sext.w	a5,a5
ffffffe000203114:	0017979b          	slliw	a5,a5,0x1
ffffffe000203118:	0007879b          	sext.w	a5,a5
ffffffe00020311c:	40f707bb          	subw	a5,a4,a5
ffffffe000203120:	0007871b          	sext.w	a4,a5
ffffffe000203124:	fdc42783          	lw	a5,-36(s0)
ffffffe000203128:	f8f42a23          	sw	a5,-108(s0)
ffffffe00020312c:	f8c42783          	lw	a5,-116(s0)
ffffffe000203130:	f8f42823          	sw	a5,-112(s0)
ffffffe000203134:	f9442783          	lw	a5,-108(s0)
ffffffe000203138:	00078593          	mv	a1,a5
ffffffe00020313c:	f9042783          	lw	a5,-112(s0)
ffffffe000203140:	00078613          	mv	a2,a5
ffffffe000203144:	0006069b          	sext.w	a3,a2
ffffffe000203148:	0005879b          	sext.w	a5,a1
ffffffe00020314c:	00f6d463          	bge	a3,a5,ffffffe000203154 <vprintfmt+0x428>
ffffffe000203150:	00058613          	mv	a2,a1
ffffffe000203154:	0006079b          	sext.w	a5,a2
ffffffe000203158:	40f707bb          	subw	a5,a4,a5
ffffffe00020315c:	fcf42c23          	sw	a5,-40(s0)
ffffffe000203160:	0280006f          	j	ffffffe000203188 <vprintfmt+0x45c>
                    putch(' ');
ffffffe000203164:	f5843783          	ld	a5,-168(s0)
ffffffe000203168:	02000513          	li	a0,32
ffffffe00020316c:	000780e7          	jalr	a5
                    ++written;
ffffffe000203170:	fec42783          	lw	a5,-20(s0)
ffffffe000203174:	0017879b          	addiw	a5,a5,1
ffffffe000203178:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe00020317c:	fd842783          	lw	a5,-40(s0)
ffffffe000203180:	fff7879b          	addiw	a5,a5,-1
ffffffe000203184:	fcf42c23          	sw	a5,-40(s0)
ffffffe000203188:	fd842783          	lw	a5,-40(s0)
ffffffe00020318c:	0007879b          	sext.w	a5,a5
ffffffe000203190:	fcf04ae3          	bgtz	a5,ffffffe000203164 <vprintfmt+0x438>
                }

                if (prefix) {
ffffffe000203194:	fa644783          	lbu	a5,-90(s0)
ffffffe000203198:	0ff7f793          	zext.b	a5,a5
ffffffe00020319c:	04078463          	beqz	a5,ffffffe0002031e4 <vprintfmt+0x4b8>
                    putch('0');
ffffffe0002031a0:	f5843783          	ld	a5,-168(s0)
ffffffe0002031a4:	03000513          	li	a0,48
ffffffe0002031a8:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
ffffffe0002031ac:	f5043783          	ld	a5,-176(s0)
ffffffe0002031b0:	0007c783          	lbu	a5,0(a5)
ffffffe0002031b4:	00078713          	mv	a4,a5
ffffffe0002031b8:	05800793          	li	a5,88
ffffffe0002031bc:	00f71663          	bne	a4,a5,ffffffe0002031c8 <vprintfmt+0x49c>
ffffffe0002031c0:	05800793          	li	a5,88
ffffffe0002031c4:	0080006f          	j	ffffffe0002031cc <vprintfmt+0x4a0>
ffffffe0002031c8:	07800793          	li	a5,120
ffffffe0002031cc:	f5843703          	ld	a4,-168(s0)
ffffffe0002031d0:	00078513          	mv	a0,a5
ffffffe0002031d4:	000700e7          	jalr	a4
                    written += 2;
ffffffe0002031d8:	fec42783          	lw	a5,-20(s0)
ffffffe0002031dc:	0027879b          	addiw	a5,a5,2
ffffffe0002031e0:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe0002031e4:	fdc42783          	lw	a5,-36(s0)
ffffffe0002031e8:	fcf42a23          	sw	a5,-44(s0)
ffffffe0002031ec:	0280006f          	j	ffffffe000203214 <vprintfmt+0x4e8>
                    putch('0');
ffffffe0002031f0:	f5843783          	ld	a5,-168(s0)
ffffffe0002031f4:	03000513          	li	a0,48
ffffffe0002031f8:	000780e7          	jalr	a5
                    ++written;
ffffffe0002031fc:	fec42783          	lw	a5,-20(s0)
ffffffe000203200:	0017879b          	addiw	a5,a5,1
ffffffe000203204:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe000203208:	fd442783          	lw	a5,-44(s0)
ffffffe00020320c:	0017879b          	addiw	a5,a5,1
ffffffe000203210:	fcf42a23          	sw	a5,-44(s0)
ffffffe000203214:	f8c42703          	lw	a4,-116(s0)
ffffffe000203218:	fd442783          	lw	a5,-44(s0)
ffffffe00020321c:	0007879b          	sext.w	a5,a5
ffffffe000203220:	fce7c8e3          	blt	a5,a4,ffffffe0002031f0 <vprintfmt+0x4c4>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000203224:	fdc42783          	lw	a5,-36(s0)
ffffffe000203228:	fff7879b          	addiw	a5,a5,-1
ffffffe00020322c:	fcf42823          	sw	a5,-48(s0)
ffffffe000203230:	03c0006f          	j	ffffffe00020326c <vprintfmt+0x540>
                    putch(buf[i]);
ffffffe000203234:	fd042783          	lw	a5,-48(s0)
ffffffe000203238:	ff078793          	addi	a5,a5,-16
ffffffe00020323c:	008787b3          	add	a5,a5,s0
ffffffe000203240:	f807c783          	lbu	a5,-128(a5)
ffffffe000203244:	0007871b          	sext.w	a4,a5
ffffffe000203248:	f5843783          	ld	a5,-168(s0)
ffffffe00020324c:	00070513          	mv	a0,a4
ffffffe000203250:	000780e7          	jalr	a5
                    ++written;
ffffffe000203254:	fec42783          	lw	a5,-20(s0)
ffffffe000203258:	0017879b          	addiw	a5,a5,1
ffffffe00020325c:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000203260:	fd042783          	lw	a5,-48(s0)
ffffffe000203264:	fff7879b          	addiw	a5,a5,-1
ffffffe000203268:	fcf42823          	sw	a5,-48(s0)
ffffffe00020326c:	fd042783          	lw	a5,-48(s0)
ffffffe000203270:	0007879b          	sext.w	a5,a5
ffffffe000203274:	fc07d0e3          	bgez	a5,ffffffe000203234 <vprintfmt+0x508>
                }

                flags.in_format = false;
ffffffe000203278:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe00020327c:	2700006f          	j	ffffffe0002034ec <vprintfmt+0x7c0>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe000203280:	f5043783          	ld	a5,-176(s0)
ffffffe000203284:	0007c783          	lbu	a5,0(a5)
ffffffe000203288:	00078713          	mv	a4,a5
ffffffe00020328c:	06400793          	li	a5,100
ffffffe000203290:	02f70663          	beq	a4,a5,ffffffe0002032bc <vprintfmt+0x590>
ffffffe000203294:	f5043783          	ld	a5,-176(s0)
ffffffe000203298:	0007c783          	lbu	a5,0(a5)
ffffffe00020329c:	00078713          	mv	a4,a5
ffffffe0002032a0:	06900793          	li	a5,105
ffffffe0002032a4:	00f70c63          	beq	a4,a5,ffffffe0002032bc <vprintfmt+0x590>
ffffffe0002032a8:	f5043783          	ld	a5,-176(s0)
ffffffe0002032ac:	0007c783          	lbu	a5,0(a5)
ffffffe0002032b0:	00078713          	mv	a4,a5
ffffffe0002032b4:	07500793          	li	a5,117
ffffffe0002032b8:	08f71063          	bne	a4,a5,ffffffe000203338 <vprintfmt+0x60c>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
ffffffe0002032bc:	f8144783          	lbu	a5,-127(s0)
ffffffe0002032c0:	00078c63          	beqz	a5,ffffffe0002032d8 <vprintfmt+0x5ac>
ffffffe0002032c4:	f4843783          	ld	a5,-184(s0)
ffffffe0002032c8:	00878713          	addi	a4,a5,8
ffffffe0002032cc:	f4e43423          	sd	a4,-184(s0)
ffffffe0002032d0:	0007b783          	ld	a5,0(a5)
ffffffe0002032d4:	0140006f          	j	ffffffe0002032e8 <vprintfmt+0x5bc>
ffffffe0002032d8:	f4843783          	ld	a5,-184(s0)
ffffffe0002032dc:	00878713          	addi	a4,a5,8
ffffffe0002032e0:	f4e43423          	sd	a4,-184(s0)
ffffffe0002032e4:	0007a783          	lw	a5,0(a5)
ffffffe0002032e8:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
ffffffe0002032ec:	fa843583          	ld	a1,-88(s0)
ffffffe0002032f0:	f5043783          	ld	a5,-176(s0)
ffffffe0002032f4:	0007c783          	lbu	a5,0(a5)
ffffffe0002032f8:	0007871b          	sext.w	a4,a5
ffffffe0002032fc:	07500793          	li	a5,117
ffffffe000203300:	40f707b3          	sub	a5,a4,a5
ffffffe000203304:	00f037b3          	snez	a5,a5
ffffffe000203308:	0ff7f793          	zext.b	a5,a5
ffffffe00020330c:	f8040713          	addi	a4,s0,-128
ffffffe000203310:	00070693          	mv	a3,a4
ffffffe000203314:	00078613          	mv	a2,a5
ffffffe000203318:	f5843503          	ld	a0,-168(s0)
ffffffe00020331c:	f08ff0ef          	jal	ffffffe000202a24 <print_dec_int>
ffffffe000203320:	00050793          	mv	a5,a0
ffffffe000203324:	fec42703          	lw	a4,-20(s0)
ffffffe000203328:	00f707bb          	addw	a5,a4,a5
ffffffe00020332c:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000203330:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe000203334:	1b80006f          	j	ffffffe0002034ec <vprintfmt+0x7c0>
            } else if (*fmt == 'n') {
ffffffe000203338:	f5043783          	ld	a5,-176(s0)
ffffffe00020333c:	0007c783          	lbu	a5,0(a5)
ffffffe000203340:	00078713          	mv	a4,a5
ffffffe000203344:	06e00793          	li	a5,110
ffffffe000203348:	04f71c63          	bne	a4,a5,ffffffe0002033a0 <vprintfmt+0x674>
                if (flags.longflag) {
ffffffe00020334c:	f8144783          	lbu	a5,-127(s0)
ffffffe000203350:	02078463          	beqz	a5,ffffffe000203378 <vprintfmt+0x64c>
                    long *n = va_arg(vl, long *);
ffffffe000203354:	f4843783          	ld	a5,-184(s0)
ffffffe000203358:	00878713          	addi	a4,a5,8
ffffffe00020335c:	f4e43423          	sd	a4,-184(s0)
ffffffe000203360:	0007b783          	ld	a5,0(a5)
ffffffe000203364:	faf43823          	sd	a5,-80(s0)
                    *n = written;
ffffffe000203368:	fec42703          	lw	a4,-20(s0)
ffffffe00020336c:	fb043783          	ld	a5,-80(s0)
ffffffe000203370:	00e7b023          	sd	a4,0(a5)
ffffffe000203374:	0240006f          	j	ffffffe000203398 <vprintfmt+0x66c>
                } else {
                    int *n = va_arg(vl, int *);
ffffffe000203378:	f4843783          	ld	a5,-184(s0)
ffffffe00020337c:	00878713          	addi	a4,a5,8
ffffffe000203380:	f4e43423          	sd	a4,-184(s0)
ffffffe000203384:	0007b783          	ld	a5,0(a5)
ffffffe000203388:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
ffffffe00020338c:	fb843783          	ld	a5,-72(s0)
ffffffe000203390:	fec42703          	lw	a4,-20(s0)
ffffffe000203394:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
ffffffe000203398:	f8040023          	sb	zero,-128(s0)
ffffffe00020339c:	1500006f          	j	ffffffe0002034ec <vprintfmt+0x7c0>
            } else if (*fmt == 's') {
ffffffe0002033a0:	f5043783          	ld	a5,-176(s0)
ffffffe0002033a4:	0007c783          	lbu	a5,0(a5)
ffffffe0002033a8:	00078713          	mv	a4,a5
ffffffe0002033ac:	07300793          	li	a5,115
ffffffe0002033b0:	02f71e63          	bne	a4,a5,ffffffe0002033ec <vprintfmt+0x6c0>
                const char *s = va_arg(vl, const char *);
ffffffe0002033b4:	f4843783          	ld	a5,-184(s0)
ffffffe0002033b8:	00878713          	addi	a4,a5,8
ffffffe0002033bc:	f4e43423          	sd	a4,-184(s0)
ffffffe0002033c0:	0007b783          	ld	a5,0(a5)
ffffffe0002033c4:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
ffffffe0002033c8:	fc043583          	ld	a1,-64(s0)
ffffffe0002033cc:	f5843503          	ld	a0,-168(s0)
ffffffe0002033d0:	dccff0ef          	jal	ffffffe00020299c <puts_wo_nl>
ffffffe0002033d4:	00050793          	mv	a5,a0
ffffffe0002033d8:	fec42703          	lw	a4,-20(s0)
ffffffe0002033dc:	00f707bb          	addw	a5,a4,a5
ffffffe0002033e0:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe0002033e4:	f8040023          	sb	zero,-128(s0)
ffffffe0002033e8:	1040006f          	j	ffffffe0002034ec <vprintfmt+0x7c0>
            } else if (*fmt == 'c') {
ffffffe0002033ec:	f5043783          	ld	a5,-176(s0)
ffffffe0002033f0:	0007c783          	lbu	a5,0(a5)
ffffffe0002033f4:	00078713          	mv	a4,a5
ffffffe0002033f8:	06300793          	li	a5,99
ffffffe0002033fc:	02f71e63          	bne	a4,a5,ffffffe000203438 <vprintfmt+0x70c>
                int ch = va_arg(vl, int);
ffffffe000203400:	f4843783          	ld	a5,-184(s0)
ffffffe000203404:	00878713          	addi	a4,a5,8
ffffffe000203408:	f4e43423          	sd	a4,-184(s0)
ffffffe00020340c:	0007a783          	lw	a5,0(a5)
ffffffe000203410:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
ffffffe000203414:	fcc42703          	lw	a4,-52(s0)
ffffffe000203418:	f5843783          	ld	a5,-168(s0)
ffffffe00020341c:	00070513          	mv	a0,a4
ffffffe000203420:	000780e7          	jalr	a5
                ++written;
ffffffe000203424:	fec42783          	lw	a5,-20(s0)
ffffffe000203428:	0017879b          	addiw	a5,a5,1
ffffffe00020342c:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000203430:	f8040023          	sb	zero,-128(s0)
ffffffe000203434:	0b80006f          	j	ffffffe0002034ec <vprintfmt+0x7c0>
            } else if (*fmt == '%') {
ffffffe000203438:	f5043783          	ld	a5,-176(s0)
ffffffe00020343c:	0007c783          	lbu	a5,0(a5)
ffffffe000203440:	00078713          	mv	a4,a5
ffffffe000203444:	02500793          	li	a5,37
ffffffe000203448:	02f71263          	bne	a4,a5,ffffffe00020346c <vprintfmt+0x740>
                putch('%');
ffffffe00020344c:	f5843783          	ld	a5,-168(s0)
ffffffe000203450:	02500513          	li	a0,37
ffffffe000203454:	000780e7          	jalr	a5
                ++written;
ffffffe000203458:	fec42783          	lw	a5,-20(s0)
ffffffe00020345c:	0017879b          	addiw	a5,a5,1
ffffffe000203460:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000203464:	f8040023          	sb	zero,-128(s0)
ffffffe000203468:	0840006f          	j	ffffffe0002034ec <vprintfmt+0x7c0>
            } else {
                putch(*fmt);
ffffffe00020346c:	f5043783          	ld	a5,-176(s0)
ffffffe000203470:	0007c783          	lbu	a5,0(a5)
ffffffe000203474:	0007871b          	sext.w	a4,a5
ffffffe000203478:	f5843783          	ld	a5,-168(s0)
ffffffe00020347c:	00070513          	mv	a0,a4
ffffffe000203480:	000780e7          	jalr	a5
                ++written;
ffffffe000203484:	fec42783          	lw	a5,-20(s0)
ffffffe000203488:	0017879b          	addiw	a5,a5,1
ffffffe00020348c:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000203490:	f8040023          	sb	zero,-128(s0)
ffffffe000203494:	0580006f          	j	ffffffe0002034ec <vprintfmt+0x7c0>
            }
        } else if (*fmt == '%') {
ffffffe000203498:	f5043783          	ld	a5,-176(s0)
ffffffe00020349c:	0007c783          	lbu	a5,0(a5)
ffffffe0002034a0:	00078713          	mv	a4,a5
ffffffe0002034a4:	02500793          	li	a5,37
ffffffe0002034a8:	02f71063          	bne	a4,a5,ffffffe0002034c8 <vprintfmt+0x79c>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
ffffffe0002034ac:	f8043023          	sd	zero,-128(s0)
ffffffe0002034b0:	f8043423          	sd	zero,-120(s0)
ffffffe0002034b4:	00100793          	li	a5,1
ffffffe0002034b8:	f8f40023          	sb	a5,-128(s0)
ffffffe0002034bc:	fff00793          	li	a5,-1
ffffffe0002034c0:	f8f42623          	sw	a5,-116(s0)
ffffffe0002034c4:	0280006f          	j	ffffffe0002034ec <vprintfmt+0x7c0>
        } else {
            putch(*fmt);
ffffffe0002034c8:	f5043783          	ld	a5,-176(s0)
ffffffe0002034cc:	0007c783          	lbu	a5,0(a5)
ffffffe0002034d0:	0007871b          	sext.w	a4,a5
ffffffe0002034d4:	f5843783          	ld	a5,-168(s0)
ffffffe0002034d8:	00070513          	mv	a0,a4
ffffffe0002034dc:	000780e7          	jalr	a5
            ++written;
ffffffe0002034e0:	fec42783          	lw	a5,-20(s0)
ffffffe0002034e4:	0017879b          	addiw	a5,a5,1
ffffffe0002034e8:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
ffffffe0002034ec:	f5043783          	ld	a5,-176(s0)
ffffffe0002034f0:	00178793          	addi	a5,a5,1
ffffffe0002034f4:	f4f43823          	sd	a5,-176(s0)
ffffffe0002034f8:	f5043783          	ld	a5,-176(s0)
ffffffe0002034fc:	0007c783          	lbu	a5,0(a5)
ffffffe000203500:	84079ce3          	bnez	a5,ffffffe000202d58 <vprintfmt+0x2c>
        }
    }

    return written;
ffffffe000203504:	fec42783          	lw	a5,-20(s0)
}
ffffffe000203508:	00078513          	mv	a0,a5
ffffffe00020350c:	0b813083          	ld	ra,184(sp)
ffffffe000203510:	0b013403          	ld	s0,176(sp)
ffffffe000203514:	0c010113          	addi	sp,sp,192
ffffffe000203518:	00008067          	ret

ffffffe00020351c <printk>:

int printk(const char* s, ...) {
ffffffe00020351c:	f9010113          	addi	sp,sp,-112
ffffffe000203520:	02113423          	sd	ra,40(sp)
ffffffe000203524:	02813023          	sd	s0,32(sp)
ffffffe000203528:	03010413          	addi	s0,sp,48
ffffffe00020352c:	fca43c23          	sd	a0,-40(s0)
ffffffe000203530:	00b43423          	sd	a1,8(s0)
ffffffe000203534:	00c43823          	sd	a2,16(s0)
ffffffe000203538:	00d43c23          	sd	a3,24(s0)
ffffffe00020353c:	02e43023          	sd	a4,32(s0)
ffffffe000203540:	02f43423          	sd	a5,40(s0)
ffffffe000203544:	03043823          	sd	a6,48(s0)
ffffffe000203548:	03143c23          	sd	a7,56(s0)
    int res = 0;
ffffffe00020354c:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
ffffffe000203550:	04040793          	addi	a5,s0,64
ffffffe000203554:	fcf43823          	sd	a5,-48(s0)
ffffffe000203558:	fd043783          	ld	a5,-48(s0)
ffffffe00020355c:	fc878793          	addi	a5,a5,-56
ffffffe000203560:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
ffffffe000203564:	fe043783          	ld	a5,-32(s0)
ffffffe000203568:	00078613          	mv	a2,a5
ffffffe00020356c:	fd843583          	ld	a1,-40(s0)
ffffffe000203570:	fffff517          	auipc	a0,0xfffff
ffffffe000203574:	11850513          	addi	a0,a0,280 # ffffffe000202688 <putc>
ffffffe000203578:	fb4ff0ef          	jal	ffffffe000202d2c <vprintfmt>
ffffffe00020357c:	00050793          	mv	a5,a0
ffffffe000203580:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
ffffffe000203584:	fec42783          	lw	a5,-20(s0)
}
ffffffe000203588:	00078513          	mv	a0,a5
ffffffe00020358c:	02813083          	ld	ra,40(sp)
ffffffe000203590:	02013403          	ld	s0,32(sp)
ffffffe000203594:	07010113          	addi	sp,sp,112
ffffffe000203598:	00008067          	ret

ffffffe00020359c <srand>:
#include "stdint.h"
#include "stdlib.h"

static uint64_t seed;

void srand(unsigned s) {
ffffffe00020359c:	fe010113          	addi	sp,sp,-32
ffffffe0002035a0:	00813c23          	sd	s0,24(sp)
ffffffe0002035a4:	02010413          	addi	s0,sp,32
ffffffe0002035a8:	00050793          	mv	a5,a0
ffffffe0002035ac:	fef42623          	sw	a5,-20(s0)
    seed = s - 1;
ffffffe0002035b0:	fec42783          	lw	a5,-20(s0)
ffffffe0002035b4:	fff7879b          	addiw	a5,a5,-1
ffffffe0002035b8:	0007879b          	sext.w	a5,a5
ffffffe0002035bc:	02079713          	slli	a4,a5,0x20
ffffffe0002035c0:	02075713          	srli	a4,a4,0x20
ffffffe0002035c4:	00006797          	auipc	a5,0x6
ffffffe0002035c8:	a5478793          	addi	a5,a5,-1452 # ffffffe000209018 <seed>
ffffffe0002035cc:	00e7b023          	sd	a4,0(a5)
}
ffffffe0002035d0:	00000013          	nop
ffffffe0002035d4:	01813403          	ld	s0,24(sp)
ffffffe0002035d8:	02010113          	addi	sp,sp,32
ffffffe0002035dc:	00008067          	ret

ffffffe0002035e0 <rand>:

int rand(void) {
ffffffe0002035e0:	ff010113          	addi	sp,sp,-16
ffffffe0002035e4:	00813423          	sd	s0,8(sp)
ffffffe0002035e8:	01010413          	addi	s0,sp,16
    seed = 6364136223846793005ULL * seed + 1;
ffffffe0002035ec:	00006797          	auipc	a5,0x6
ffffffe0002035f0:	a2c78793          	addi	a5,a5,-1492 # ffffffe000209018 <seed>
ffffffe0002035f4:	0007b703          	ld	a4,0(a5)
ffffffe0002035f8:	00001797          	auipc	a5,0x1
ffffffe0002035fc:	f0878793          	addi	a5,a5,-248 # ffffffe000204500 <lowerxdigits.0+0x18>
ffffffe000203600:	0007b783          	ld	a5,0(a5)
ffffffe000203604:	02f707b3          	mul	a5,a4,a5
ffffffe000203608:	00178713          	addi	a4,a5,1
ffffffe00020360c:	00006797          	auipc	a5,0x6
ffffffe000203610:	a0c78793          	addi	a5,a5,-1524 # ffffffe000209018 <seed>
ffffffe000203614:	00e7b023          	sd	a4,0(a5)
    return seed >> 33;
ffffffe000203618:	00006797          	auipc	a5,0x6
ffffffe00020361c:	a0078793          	addi	a5,a5,-1536 # ffffffe000209018 <seed>
ffffffe000203620:	0007b783          	ld	a5,0(a5)
ffffffe000203624:	0217d793          	srli	a5,a5,0x21
ffffffe000203628:	0007879b          	sext.w	a5,a5
}
ffffffe00020362c:	00078513          	mv	a0,a5
ffffffe000203630:	00813403          	ld	s0,8(sp)
ffffffe000203634:	01010113          	addi	sp,sp,16
ffffffe000203638:	00008067          	ret

ffffffe00020363c <memset>:
#include "string.h"
#include "stdint.h"
#include "printk.h"

void *memset(void *dest, int c, uint64_t n) {
ffffffe00020363c:	fc010113          	addi	sp,sp,-64
ffffffe000203640:	02813c23          	sd	s0,56(sp)
ffffffe000203644:	04010413          	addi	s0,sp,64
ffffffe000203648:	fca43c23          	sd	a0,-40(s0)
ffffffe00020364c:	00058793          	mv	a5,a1
ffffffe000203650:	fcc43423          	sd	a2,-56(s0)
ffffffe000203654:	fcf42a23          	sw	a5,-44(s0)
    // printk("dest = 0x%lx\n", dest);
    char *s = (char *)dest;
ffffffe000203658:	fd843783          	ld	a5,-40(s0)
ffffffe00020365c:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000203660:	fe043423          	sd	zero,-24(s0)
ffffffe000203664:	0280006f          	j	ffffffe00020368c <memset+0x50>
        s[i] = c;
ffffffe000203668:	fe043703          	ld	a4,-32(s0)
ffffffe00020366c:	fe843783          	ld	a5,-24(s0)
ffffffe000203670:	00f707b3          	add	a5,a4,a5
ffffffe000203674:	fd442703          	lw	a4,-44(s0)
ffffffe000203678:	0ff77713          	zext.b	a4,a4
ffffffe00020367c:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000203680:	fe843783          	ld	a5,-24(s0)
ffffffe000203684:	00178793          	addi	a5,a5,1
ffffffe000203688:	fef43423          	sd	a5,-24(s0)
ffffffe00020368c:	fe843703          	ld	a4,-24(s0)
ffffffe000203690:	fc843783          	ld	a5,-56(s0)
ffffffe000203694:	fcf76ae3          	bltu	a4,a5,ffffffe000203668 <memset+0x2c>
    }
    return dest;
ffffffe000203698:	fd843783          	ld	a5,-40(s0)
}
ffffffe00020369c:	00078513          	mv	a0,a5
ffffffe0002036a0:	03813403          	ld	s0,56(sp)
ffffffe0002036a4:	04010113          	addi	sp,sp,64
ffffffe0002036a8:	00008067          	ret

ffffffe0002036ac <memcpy>:

void *memcpy(void *dst, void *src, uint64_t n) {
ffffffe0002036ac:	fb010113          	addi	sp,sp,-80
ffffffe0002036b0:	04813423          	sd	s0,72(sp)
ffffffe0002036b4:	05010413          	addi	s0,sp,80
ffffffe0002036b8:	fca43423          	sd	a0,-56(s0)
ffffffe0002036bc:	fcb43023          	sd	a1,-64(s0)
ffffffe0002036c0:	fac43c23          	sd	a2,-72(s0)
    char *cdst = (char *)dst;
ffffffe0002036c4:	fc843783          	ld	a5,-56(s0)
ffffffe0002036c8:	fef43023          	sd	a5,-32(s0)
    char *csrc = (char *)src;
ffffffe0002036cc:	fc043783          	ld	a5,-64(s0)
ffffffe0002036d0:	fcf43c23          	sd	a5,-40(s0)
    for (uint64_t i = 0; i < n; ++i)
ffffffe0002036d4:	fe043423          	sd	zero,-24(s0)
ffffffe0002036d8:	0300006f          	j	ffffffe000203708 <memcpy+0x5c>
        cdst[i] = csrc[i];
ffffffe0002036dc:	fd843703          	ld	a4,-40(s0)
ffffffe0002036e0:	fe843783          	ld	a5,-24(s0)
ffffffe0002036e4:	00f70733          	add	a4,a4,a5
ffffffe0002036e8:	fe043683          	ld	a3,-32(s0)
ffffffe0002036ec:	fe843783          	ld	a5,-24(s0)
ffffffe0002036f0:	00f687b3          	add	a5,a3,a5
ffffffe0002036f4:	00074703          	lbu	a4,0(a4)
ffffffe0002036f8:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i)
ffffffe0002036fc:	fe843783          	ld	a5,-24(s0)
ffffffe000203700:	00178793          	addi	a5,a5,1
ffffffe000203704:	fef43423          	sd	a5,-24(s0)
ffffffe000203708:	fe843703          	ld	a4,-24(s0)
ffffffe00020370c:	fb843783          	ld	a5,-72(s0)
ffffffe000203710:	fcf766e3          	bltu	a4,a5,ffffffe0002036dc <memcpy+0x30>
    return dst;
ffffffe000203714:	fc843783          	ld	a5,-56(s0)
}
ffffffe000203718:	00078513          	mv	a0,a5
ffffffe00020371c:	04813403          	ld	s0,72(sp)
ffffffe000203720:	05010113          	addi	sp,sp,80
ffffffe000203724:	00008067          	ret

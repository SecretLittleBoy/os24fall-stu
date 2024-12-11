#include "stdint.h"
#include "sbi.h"
#include "printk.h"

// QEMU 中时钟的频率是 10MHz，也就是 1 秒钟相当于 10000000 个时钟周期
uint64_t TIMECLOCK = 10000000;

uint64_t get_cycles() {
    // 编写内联汇编，使用 rdtime 获取 time 寄存器中（也就是 mtime 寄存器）的值并返回
    uint64_t cycles;
    // printk("enter cycles\n");
    __asm__ volatile(
            "rdtime %[cycles]\n"
            : [cycles] "=r" (cycles)
            :
            : "memory"
            );
    return cycles;
}

void clock_set_next_event() {
    // 下一次时钟中断的时间点
    uint64_t next = get_cycles() + TIMECLOCK;

    // 使用 sbi_set_timer 来完成对下一次时钟中断的设置
    sbi_set_timer(next);
}
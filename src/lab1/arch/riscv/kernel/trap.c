#include "stdint.h"
#include "../../../include/printk.h"
#include "../include/clock.h"

#define INTERRUPT_SIG 0x8000000000000000
#define TIMER_INTERRUPT_SIG 0x5

void trap_handler(uint64_t scause, uint64_t sepc) {
    // 通过 `scause` 判断 trap 类型
    // 如果是 interrupt 判断是否是 timer interrupt
    // 如果是 timer interrupt 则打印输出相关信息，并通过 `clock_set_next_event()` 设置下一次时钟中断
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试

    if (scause & INTERRUPT_SIG) { // it's interrupt
        scause = scause - INTERRUPT_SIG;
        if (!(scause ^ TIMER_INTERRUPT_SIG)) { // it's Supervisor timer interrupt
            printk("[S] Supervisor Mode Timer Interrupt\n");
            clock_set_next_event();
            return;
        }
    }

    printk("other interrupt or exception\n");
}
#include "stdint.h"
#include "sbi.h"
extern uint64_t TIMECLOCK;

void output_string(const char *str) {
    uint64_t base_addr_lo = (uint64_t)(uintptr_t)str;
    uint64_t base_addr_hi = (uintptr_t)(str)>>32;
    // 计算字符串的长度
    int length = 0;
    const char *p = str;
    while (p[length] != '\0') {
        length++;
    }
    sbi_debug_console_write(length, base_addr_lo, base_addr_hi);
}


void trap_handler(uint64_t scause, uint64_t sepc) {
    // 通过 `scause` 判断 trap 类型
    uint64_t highest_bit = 0x8000000000000000;
    uint64_t rest_bit = scause - highest_bit;
    if (scause & highest_bit != 0) {
        output_string("Interrupt\n");
        if (rest_bit == 5){
            output_string("Supervisor timer interrupt\n");
            // output_string("Timer interrupt occurred at address:\n");
            // output_string(&sepc);
            clock_set_next_event();
        } else if (rest_bit == 1){
            output_string("Supervisor software interrupt\n");
        } else if (rest_bit == 9){
            output_string("Supervisor external interrupt\n");
        } else if (rest_bit == 13){
            output_string("Counter-overflow interrupt\n");
        } else {
            output_string("Designated for platform use\n");
        }
    } else {
        output_string("No Interrupt\n");
    }
    // 如果是 interrupt 判断是否是 timer interrupt
    // 如果是 timer interrupt 则打印输出相关信息，并通过 `clock_set_next_event()` 设置下一次时钟中断
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试

}
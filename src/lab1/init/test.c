#include "sbi.h"
#include "printk.h"

#define LAB1_STAGE 2

#if LAB1_STAGE == 1

void test() {
    sbi_system_reset(SBI_SRST_RESET_TYPE_SHUTDOWN, SBI_SRST_RESET_REASON_NONE);
    __builtin_unreachable();
}

#elif LAB1_STAGE == 2

void test() {
    int i = 0;
    while (1) {
        if ((++i) % 100000000 == 0) {
            printk("kernel is running!\n");
            i = 0;
        }
    }
}

#endif
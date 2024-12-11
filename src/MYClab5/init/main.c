#include "printk.h"
#include "sbi.h"
#include "proc.h"

extern void test();

int start_kernel() {
    printk(GREEN "2024" CLEAR);
    printk(GREEN " ZJU Operating System\n" CLEAR);
    schedule();
    test();
    return 0;
}

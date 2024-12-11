#include "stdint.h"
#include "sbi.h"
#include "printk.h"
#include "proc.h"
#include "defs.h"
#include "syscall.h"
#include "string.h"

extern uint64_t TIMECLOCK;
extern struct task_struct* current;
extern char _sramdisk[];

struct pt_regs {
    uint64_t gpr[32];   // 通用寄存器 x0 ~ x31
    uint64_t sepc;      // 异常发生时的返回地址
};

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

void trap_handler(uint64_t scause, uint64_t sepc, struct pt_regs *regs) {
    // 通过 `scause` 判断 trap 类型
    uint64_t highest_bit = 0x8000000000000000;
    int is_interrupt = scause & highest_bit;
    uint64_t rest_bit = scause - highest_bit;
    if (is_interrupt) {
        if (rest_bit == 5){
             // output_string("[S] Supervisor Mode Timer Interrupt\n");
            clock_set_next_event();
            do_timer();
        } else {
            Err("Unhandled Interrupt: scause=%d, sepc=0x%x\n", scause,sepc );
        }
    } else if (scause == 8) { // Environment call from U-mode
        syscall(regs);
    } else if (scause == 12 || scause == 13 || scause == 15){
        uint64_t stval = csr_read(stval);
        uint64_t sepc = csr_read(sepc);
        Info("[PID=%d, PC=0x%x] valid page fault at [0x%x] with scause %d", current->pid, sepc, stval, scause);
        do_page_fault(regs);
    } else {
        Err("Unhandled Exception: scause=%d, sepc=0x%x\n", scause, sepc);
    }
    // 如果是 interrupt 判断是否是 timer interrupt
    // 如果是 timer interrupt 则打印输出相关信息，并通过 `clock_set_next_event()` 设置下一次时钟中断
    // `clock_set_next_event()` 见 4.3.4 节
    // 其他 interrupt / exception 可以直接忽略，推荐打印出来供以后调试

}

void syscall(struct pt_regs *regs){
    uint64_t syscall_num = regs->gpr[17]; // a7
    uint64_t arg0 = regs->gpr[10];        // a0
    uint64_t arg1 = regs->gpr[11];        // a1
    uint64_t arg2 = regs->gpr[12];        // a2
    // printk("syscall number = %llx\n", syscall_num);
    switch (syscall_num) {
        case SYS_WRITE:
            if (arg0 == 1){
                char* buf = (char* )(arg1);
                for (uint64_t i = 0; i < arg2; i++) {
                    printk("%c", buf[i]);
                }
                regs->gpr[10] = arg2;
            } else {
                printk("Can't call syscall write.\n");
                regs->gpr[10] = -1;
            }
            break;
        case SYS_GETPID:
            regs->gpr[10] = current->pid;
            break;
        default:
            regs->gpr[10] = -1; // 默认返回值为-1
            break;
    }
    regs->sepc += 4;
    uint64_t sepc = csr_read(sepc);
    // 不知道是否需要，先留着
//    sepc += 4;
//    csr_write(sepc, sepc);
}

/* 实现page-fault handler */
void do_page_fault(struct pt_regs *regs) {
//    Err("Function not implemented. \n");
    // uint64_t bad_addr = regs->stval;  //获得访问出错的虚拟内存地址
    uint64_t bad_addr = csr_read(stval);
    uint64_t scause = csr_read(scause);
    // printk("bad addr = 0x%x\n", bad_addr);
    struct vm_area_struct *vma = find_vma(current->mm,bad_addr);    //查找bad_addr是否在某个vma中
    if(vma == NULL) {
        // 非预期错误
        Err("Can't find vma in address %lx! pid: %d\n", bad_addr, current->pid);
    }
    uint64_t perm = vma->vm_flags;
    if(vma != NULL){
        // 根据scause的值和vma的perm判断当前访问是否合法
        int perm = ((vma->vm_flags) & (~VM_ANON)) | 0xd1;
        int is_exec = !(perm & VM_EXEC == 0);
        int is_read = !(perm & VM_READ == 0);
        int is_write = !(perm & VM_WRITE == 0);
        int is_anon = vma->vm_flags & VM_ANON;
        if (scause == 12 && !is_exec){
            // Instruction Page Fault，需要有exec权限
            Err("Instruction Page Fault, but perm is : read %d, write %d, exec %d\n", is_read, is_write, is_exec);
        }else if (scause == 13 && !is_read) {
            // Load Page Fault， 需要有read权限
            Err("Load Page Fault, but perm is : read %d, write %d, exec %d\n", is_read, is_write, is_exec);
        }else if (scause == 15 && !is_write){
            // Store/AMO Page Fault， 需要有write权限
            Err("Store/AMO Page Fault, but perm is : read %d, write %d, exec %d\n", is_read, is_write, is_exec);
        }
        // 权限没有错误
        uint64_t new_page = alloc_page();
        if (is_anon){
            // 是匿名空间，直接映射
            memset((void *)new_page, 0x0, PGSIZE); // 清空页内容
            create_mapping(current->pgd,PGROUNDDOWN(bad_addr),(uint64_t)new_page-PA2VA_OFFSET,PGSIZE,perm);
        } else {
            uint64_t begin_addr = (uint64_t)(_sramdisk) + vma->vm_pgoff;
            uint64_t num_page = (bad_addr - vma->vm_start) / PGSIZE;
            begin_addr += num_page * PGSIZE;
            memcpy((void *)new_page, (void *)PGROUNDDOWN(begin_addr), PGSIZE);
            create_mapping(current->pgd,PGROUNDDOWN(bad_addr),(uint64_t)new_page-PA2VA_OFFSET,PGSIZE,perm);
        }
    }
}
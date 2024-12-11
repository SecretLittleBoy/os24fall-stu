#include "mm.h"
#include "defs.h"
#include "proc.h"
#include "stdlib.h"
#include "printk.h"
#include "string.h"
#include "elf.h"

extern void __dummy();
extern char _sramdisk[];
extern char _eramdisk[];
extern uint64_t swapper_pg_dir[512];

struct task_struct *idle;           // idle process
struct task_struct *current;        // 指向当前运行线程的 task_struct
struct task_struct *task[NR_TASKS]; // 线程数组，所有的线程都保存在此

void task_init() {
    // 1. 调用 kalloc() 为 idle 分配一个物理页
    // 2. 设置 state 为 TASK_RUNNING;
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // idle->thread.ra = (uint64_t)__dummy;
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle
    srand(2024);
    idle = (struct task_struct* )kalloc(); // 类型转换
    if (idle == NULL) {
        printk("kalloc失败\n");
    } else {
        idle->state = TASK_RUNNING;
        idle->counter = 0;
        idle->priority = 1;
        idle->pid = 0;
    }
    current = idle;
    task[0] = idle;

    // 1. 参考 idle 的设置，为 task[1] ~ task[NR_TASKS - 1] 进行初始化
    // 2. 其中每个线程的 state 为 TASK_RUNNING, 此外，counter 和 priority 进行如下赋值：
    //task[i].counter  = 0;
    //task[i].priority = rand() 产生的随机数（控制范围在 [PRIORITY_MIN, PRIORITY_MAX] 之间）
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.3.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址
    for (int i = 1; i < NR_TASKS; i++){
        task[i] = (struct task_struct* )kalloc();
        task[i]->state = TASK_RUNNING;
        task[i]->counter = 0;
        task[i]->priority = rand() % (PRIORITY_MAX - PRIORITY_MIN + 1) + PRIORITY_MIN;
        task[i]->pid = i;
        task[i]->thread.ra = (uint64_t)(&__dummy);
        task[i]->thread.sp = (uint64_t)task[i] + PGSIZE;

        // 用户态相关设置
        // 设置kernel stack和user stack
        task[i]->kernel_sp = (uint64_t)task[i] + PGSIZE;
        // task[i]->user_sp = alloc_page(); // 新分配一个page
        uint64_t* new_pgtbl = (uint64_t*)alloc_page(); // 新分配一个pgtbl
        memcpy(new_pgtbl, swapper_pg_dir, PGSIZE);
        task[i]->pgd = new_pgtbl;
        // 将uapp和user stack映射到新的pgtbl中
//        uint64_t va = USER_START;
//        uint64_t size = _eramdisk - _sramdisk;
//        uint64_t num_page = (size + PGSIZE - 1) / PGSIZE; // 需要的页数
//        uint64_t uapp_space = alloc_pages(num_page);
//        memcpy((uint64_t*)uapp_space, _sramdisk, size); // 拷贝uapp
//        uint64_t pa = uapp_space - PA2VA_OFFSET; // 物理地址
//        // printk("va = %llx, pa = %llx, size = %llx\n", va, pa, size);
//        create_mapping(task[i]->pgd, va, pa, size, 0x1f);
//        pa = task[i]->user_sp - PA2VA_OFFSET;
//        va = USER_END - PGSIZE;
//        create_mapping(task[i]->pgd, va, pa, PGSIZE, 0x17); // 映射stack

        // 使用 do_mmap 来为用户程序段和栈分配 VMA
        Elf64_Ehdr *ehdr = (Elf64_Ehdr *)_sramdisk;
        Elf64_Phdr *phdrs = (Elf64_Phdr *)(_sramdisk + ehdr->e_phoff);
        task[i]->mm = (struct mm_struct*)kalloc();
        task[i]->mm->mmap = NULL;
         // 对于elf中的每个section
        for (int k = 0; k < ehdr->e_phnum; ++k) {
            Elf64_Phdr *phdr = phdrs + k;
            if (phdr->p_type == PT_LOAD) {
                uint64_t flags = phdr->p_flags << 1; // phdr的flag和vma中的flag不一样
                do_mmap(task[i]->mm, phdr->p_vaddr, phdr->p_memsz, phdr->p_offset, phdr->p_filesz, flags);
            }
        }
        do_mmap(task[i]->mm, USER_END - PGSIZE, PGSIZE, 0, 0, VM_READ | VM_WRITE | VM_ANON); // 用户栈

        // 更新各种寄存器：sepc, sstatus, sscratch, satp
        task[i]->thread.sepc = ehdr->e_entry; // 记得设置sepc!!
        uint64_t sstatus = task[i]->thread.sstatus;
        sstatus &= ~(1 << 8);
        sstatus |= (1 << 5);
        sstatus |= (1 << 18);
        task[i]->thread.sstatus = sstatus;
        task[i]->thread.sscratch = USER_END;
        uint64_t curr_pgd = (uint64_t)(task[i]->pgd);
        uint64_t curr_satp = csr_read(satp);
        curr_satp = (curr_satp >> 44) << 44; // 清除信息
        curr_satp |= ((curr_pgd - PA2VA_OFFSET) >> 12); // 写入当前task的PPN
        curr_satp |= (0x8 << 60); // 设置格式
        task[i]->satp = curr_satp;
        // load_program(task[i]);
    }
    printk("...task_init done!\n");
    return;
}

#ifdef TEST_SCHED
#define MAX_OUTPUT ((NR_TASKS - 1) * 10)
char tasks_output[MAX_OUTPUT];
int tasks_output_index = 0;
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif
extern void __switch_to(struct task_struct *prev, struct task_struct *next);

void switch_to(struct task_struct *next) {
    // YOUR CODE HERE
    if (current->pid == next->pid){
        return;
    }
    struct task_struct*tmp = current;
    current = next ;
    __switch_to(tmp, next);
}

void dummy() {
    // printk("enter dummy\n");
    uint64_t MOD = 1000000007;
    uint64_t auto_inc_local_var = 0;
    int last_counter = -1;
    // printk("current->counter =%d\n ", current->counter);
    while (1) {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
            if (current->counter == 1) {
                --(current->counter);   // forced the counter to be zero if this thread is going to be scheduled
            }                           // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
            printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
            #ifdef TEST_SCHED
            tasks_output[tasks_output_index++] = current->pid + '0';
            if (tasks_output_index == MAX_OUTPUT) {
                for (int i = 0; i < MAX_OUTPUT; ++i) {
                    if (tasks_output[i] != expected_output[i]) {
                        printk("\033[31mTest failed!\033[0m\n");
                        printk("\033[31m    Expected: %s\033[0m\n", expected_output);
                        printk("\033[31m    Got:      %s\033[0m\n", tasks_output);
                        sbi_system_reset(SBI_SRST_RESET_TYPE_SHUTDOWN, SBI_SRST_RESET_REASON_NONE);
                    }
                }
                printk("\033[32mTest passed!\033[0m\n");
                printk("\033[32m    Output: %s\033[0m\n", expected_output);
                sbi_system_reset(SBI_SRST_RESET_TYPE_SHUTDOWN, SBI_SRST_RESET_REASON_NONE);
            }
            #endif
        }
    }
}

void schedule() {
    struct task_struct* next = current;
    uint64_t max = 0;
    // 查找具有最大 counter 值的线程，如果没有，则reschedule并且继续查找
    while (1){
        for (int i = 0; i < NR_TASKS; i++) {
            if (task[i]->state == TASK_RUNNING && task[i]->counter > 0){
                if (task[i]->counter > max){
                    max = task[i]->counter;
                    next = task[i];
                }
            }
        }
        if (max > 0){
            break;
        } else {
            // 如果没有找到具有正 counter 的线程，则重新初始化所有线程的 counter
            for (int i = 1; i < NR_TASKS; i++) {
                // 如果所有线程 counter 都为 0，则令所有线程 counter = priority
                task[i]->counter = task[i]->priority;
                // 重新调度
                printk("SET [PID = %d PRIORITY = %d COUNTER = %d]\n", task[i]->pid, task[i]->priority, task[i]->counter);
            }
        }
    }
    // 切换到选定的线程
    printk(BLUE "\nswitch to [PID = %d COUNTER = %d PRIORITY = %d]\n" CLEAR,next->pid,next->counter,next->priority);
    switch_to(next);
}

void do_timer() {
    // 1. 如果当前线程是 idle 线程或当前线程时间片耗尽则直接进行调度
    // printk("enter do_timer\n");
    if (current->pid == 0 || current->counter == 0){
        schedule();
        return;
    } else {
        // 2. 否则对当前线程的运行剩余时间减 1，若剩余时间仍然大于 0 则直接返回，否则进行调度
        current->counter -= 1;
        if (current->counter > 0) {
            // printk("current task is %d, counter = %d\n", current->pid, current->counter);
            return;
        } else {
            schedule();
        }
    }
}

// 将elf文件加载入uapp中
static void load_program(struct task_struct *task) {
    Elf64_Ehdr *ehdr = (Elf64_Ehdr *)_sramdisk;
    Elf64_Phdr *phdrs = (Elf64_Phdr *)(_sramdisk + ehdr->e_phoff);
    for (int i = 0; i < ehdr->e_phnum; ++i) {
        // printk("mapping %d-th ehdr into %d-th task\n", i, task->pid);
        Elf64_Phdr *phdr = phdrs + i;
        if (phdr->p_type == PT_LOAD) {
            // 计算所需页面数量并分配空间
            uint64_t num_page = ((uint64_t)phdr->p_memsz + PGSIZE - 1) / PGSIZE;
            uint64_t *new_space = (uint64_t*)alloc_pages(num_page);
            uint64_t filesz = (uint64_t)phdr->p_filesz;
            uint64_t memsz = (uint64_t)phdr->p_memsz;
            uint64_t prem = (phdr->p_flags << 1) | 17;
            // 定义offset，使得地址都是页对齐的
            uint64_t start_offset = phdr->p_vaddr - PGROUNDDOWN(phdr->p_vaddr);
            // 拷贝elf文件到new allocated space
            memcpy((void *)((uint64_t)new_space + start_offset),
                   (void*)((uint64_t)&_sramdisk + (uint64_t)phdr->p_offset),
                   filesz);
            // 如果mem size > file size, 清零多余空间
            memset((void *)((uint64_t)new_space + start_offset + filesz),
                   0,
                   (uint64_t)phdr->p_memsz-filesz);
            // create mapping
            uint64_t va = (uint64_t)phdr->p_vaddr;
            uint64_t pa = (uint64_t)new_space-PA2VA_OFFSET;
            create_mapping(task->pgd, va, pa, num_page*PGSIZE, prem);
        }
    }
    task->thread.sepc = ehdr->e_entry;
}

struct vm_area_struct *find_vma(struct mm_struct *mm, uint64_t addr){
    // printk("Enter find_vma\n");
    struct vm_area_struct *vma = mm->mmap;
    while (vma) {
        // 如果 addr 在 vma 所表示的地址范围内
        if (addr >= vma->vm_start && addr < vma->vm_end) {
            // printk("vma start = 0x%x, vma end = 0x%x\n", vma->vm_start, vma->vm_end);
            return vma;
        }
        vma = vma->vm_next;
    }
    return NULL;
}

uint64_t do_mmap(struct mm_struct *mm, uint64_t addr,
        uint64_t len, uint64_t vm_pgoff, uint64_t vm_filesz, uint64_t flags){
    struct vm_area_struct* vma = (struct vm_area_struct*)kalloc();
    vma->vm_mm = mm;
    vma->vm_start = addr;
    vma->vm_end = addr + len;
    vma->vm_pgoff = vm_pgoff;
    vma->vm_filesz = vm_filesz;
    vma->vm_flags = flags;
    vma->vm_next = NULL;
    vma->vm_prev = NULL;

    struct vm_area_struct* current = mm->mmap;
    // 当前mm的vma链表为空
    if (current == NULL) {
        mm->mmap = vma;
    } else {
        while (current->vm_next) {
            current = current->vm_next;
        }
        current->vm_next = vma;
        vma->vm_prev = current;
    }
    return addr;
}
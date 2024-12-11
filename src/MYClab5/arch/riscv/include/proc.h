#ifndef __PROC_H__
#define __PROC_H__

#include "stdint.h"

#ifdef TEST_SCHED
#define NR_TASKS (1 + 4)    // 测试时线程数量
#else
// #define NR_TASKS (1 + 31)   // 用于控制最大线程数量（idle 线程 + 31 内核线程）
//#define NR_TASKS (1 + 4) // 调试用，较小的NR_TASKS
#define NR_TASKS (1 + 4) // lab4专用
// #define NR_TASKS (1 + 1) // lab5专用

#endif

#define TASK_RUNNING 0      // 为了简化实验，所有的线程都只有一种状态

#define PRIORITY_MIN 1
#define PRIORITY_MAX 10


/*定义vma结构体*/
// 每一个 vm_area_struct 都对应于 task 地址空间的唯一连续区间。
struct vm_area_struct {
    struct mm_struct *vm_mm;    // 所属的 mm_struct
    uint64_t vm_start;          // VMA 对应的用户态虚拟地址的开始
    uint64_t vm_end;            // VMA 对应的用户态虚拟地址的结束
    struct vm_area_struct *vm_next, *vm_prev;   // 链表指针
    uint64_t vm_flags;          // VMA 对应的 flags
    // struct file *vm_file;    // 对应的文件（目前还没实现，而且我们只有一个 uapp 所以暂不需要）
    uint64_t vm_pgoff;          // 如果对应了一个文件，那么这块 VMA 起始地址对应的文件内容相对文件起始位置的偏移量
    uint64_t vm_filesz;         // 对应的文件内容的长度
};

struct mm_struct {
    struct vm_area_struct *mmap;
};

/* 线程状态段数据结构 */
struct thread_struct {
    uint64_t ra;
    uint64_t sp;
    uint64_t s[12];
    uint64_t sepc, sstatus, sscratch;
    // uint64_t satp; // 与用户态相关的寄存器变量
};

/* 线程数据结构 */
struct task_struct {
    uint64_t state;     // 线程状态
    uint64_t counter;   // 运行剩余时间
    uint64_t priority;  // 运行优先级 1 最低 10 最高
    uint64_t pid;       // 线程 id

    struct thread_struct thread;
    uint64_t satp; // satp，因为pgd会改变所以每个task的satp也不相同
    uint64_t *pgd;  // 用户态页表
    uint64_t kernel_sp; // kernel space的stack
    uint64_t user_sp; // user space的stack
    struct mm_struct* mm; // 新添加的
};

/* 线程初始化，创建 NR_TASKS 个线程 */
void task_init();

/* 在时钟中断处理中被调用，用于判断是否需要进行调度 */
void do_timer();

/* 调度程序，选择出下一个运行的线程 */
void schedule();

/* 线程切换入口函数 */
void switch_to(struct task_struct *next);

/* dummy funciton: 一个循环程序，循环输出自己的 pid 以及一个自增的局部变量 */
void dummy();

/* Load函数，用于将elf文件加载到_sramdisk开始的地址（即uapp）中 */
static void load_program(struct task_struct* task);

/* find_vma函数，实现对vma_struct的查找 */
/*
* @mm       : current thread's mm_struct
* @addr     : the va to look up
*
* @return   : the VMA if found or NULL if not found
*/
struct vm_area_struct *find_vma(struct mm_struct *mm, uint64_t addr);

/* do_mmap 函数：实现 vm_area_struct 的添加 */
/*
* @mm       : current thread's mm_struct
* @addr     : the va to map
* @len      : memory size to map
* @vm_pgoff : phdr->p_offset
* @vm_filesz: phdr->p_filesz
* @flags    : flags for the new VMA
*
* @return   : start va
*/
uint64_t do_mmap(struct mm_struct *mm, uint64_t addr, uint64_t len, uint64_t vm_pgoff, uint64_t vm_filesz, uint64_t flags);

#endif

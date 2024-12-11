// 必须要申明为char []
extern char _skernel[];
extern char _ekernel[];
extern char _stext[];
extern char _etext[];
extern char _srodata[];
extern char _erodata[];
extern char _sdata[];
extern char _edata[];
extern char _sbss[];
extern char _ebss[];

#include <stdint.h>
#include <defs.h>
#include <printk.h>
#include <string.h>

/* early_pgtbl: 用于 setup_vm 进行 1GiB 的映射 */
uint64_t early_pgtbl[512] __attribute__((__aligned__(0x1000)));

void setup_vm() {
    /*
     * 1. 由于是进行 1GiB 的映射，这里不需要使用多级页表
     * 2. 将 va 的 64bit 作为如下划分： | high bit | 9 bit | 30 bit |
     *     high bit 可以忽略
     *     中间 9 bit 作为 early_pgtbl 的 index
     *     低 30 bit 作为页内偏移，这里注意到 30 = 9 + 9 + 12，即我们只使用根页表，根页表的每个 entry 都对应 1GiB 的区域
     * 3. Page Table Entry 的权限 V | R | W | X 位设置为 1
    **/
    memset(early_pgtbl, 0x0, PGSIZE); // 初始化pgtbl
    uint64_t va = PHY_START; // 等值映射
    uint64_t pa = PHY_START; // 偏移映射
    // 中间 9 bit 作为 early_pgtbl 的 index
    // 权限：后四位XWRV都为1
    early_pgtbl[(va >> 30) & 0x1ff] = (((pa >> 30) & 0x3ffffff)<<28) | 0xf; // 映射大小为1GB，取PPN[2],即30-55一部分
    va = VM_START; // 偏移映射
    early_pgtbl[(va >> 30) & 0x1ff] = (((pa >> 30) & 0x3ffffff)<<28) | 0xf;
    printk("...set up vm done!\n");
}

/* swapper_pg_dir: kernel pagetable 根目录，在 setup_vm_final 进行映射 */
uint64_t swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

void setup_vm_final() {
    memset(swapper_pg_dir, 0x0, PGSIZE); // 清空根页表
    // No OpenSBI mapping required
    uint64_t va = VM_START + OPENSBI_SIZE; // vmlinux.lds-MEMORY
    uint64_t pa = PHY_START + OPENSBI_SIZE;
    // mapping kernel text X|-|R|V
    create_mapping(swapper_pg_dir, va, pa, _srodata - _stext, 0xB);
    printk("...kernel text mapping done\n");

    // mapping kernel rodata -|-|R|V
    va += _srodata - _stext;
    pa += _srodata - _stext;
    create_mapping(swapper_pg_dir, va, pa, _sdata - _srodata, 0x3);
    printk("...kernel rodata mapping done\n");

    // mapping other memory -|W|R|V
    va += _sdata - _srodata;
    pa += _sdata - _srodata;
    create_mapping(swapper_pg_dir, va, pa, PHY_SIZE - (_sdata - _stext), 0x7);
    printk("...other memory mapping done\n");

    // set satp with swapper_pg_dir
    // 注意satp中需要存放PPN：1. 是物理地址（需要减去PA2VA_OFFSET）；2. 是PPN（需要移除page offset）
    uint64_t _satp = (((unsigned long)swapper_pg_dir - PA2VA_OFFSET) >> 12) | (8L << 60); // 设置mode
    csr_write(satp, _satp);

    // flush TLB
    asm volatile("sfence.vma zero, zero");

    printk("...setup vm final done!\n");
    return;
}


/* 创建多级页表映射关系 */
/* 不要修改该接口的参数和返回值 */
void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm) {
    /*
     * pgtbl 为根页表的基地址
     * va, pa 为需要映射的虚拟地址、物理地址
     * sz 为映射的大小，单位为字节
     * perm 为映射的权限（即页表项的低 8 位）
     *
     * 创建多级页表的时候可以使用 kalloc() 来获取一页作为页表目录
     * 可以使用 V bit 来判断页表项是否存在
    **/
    uint64_t vpn[3];          // 虚拟页号，分别表示三级页表的索引
    uint64_t curr_pa = pa;    // 当前物理地址
    uint64_t curr_va = va;    // 当前虚拟地址
    uint64_t end_va = va + sz; // 计算结束的虚拟地址
    uint64_t end_pa = pa + sz;
    uint64_t *curr_tbl = pgtbl;
    Info("root[0x%x], [0x%lx, 0x%lx)->[0x%lx, 0x%lx), perm=%x", pgtbl, pa, end_pa, va, end_va, perm);

    while(curr_va < end_va){
        // 获取各个层级的vpn
        vpn[0] = (curr_va >> 12) & 0x1ff;
        vpn[1] = (curr_va >> 21) & 0x1ff;
        vpn[2] = (curr_va >> 30) & 0x1ff;

        uint64_t *curr_pgtbl = pgtbl;
        if (!(curr_pgtbl[vpn[2]] & 0x1)) { // 如果V bit为0，不存在
            uint64_t *new_pgd = (uint64_t*)(alloc_page() - PA2VA_OFFSET); // 物理地址
            curr_pgtbl[vpn[2]] = (((uint64_t)new_pgd >> 12) << 10 | 0x1);
        }
        // curr_pgtbl = (uint64_t *)((curr_pgtbl[vpn[2]] >> 10) << 12) + PA2VA_OFFSET; // 虚拟地址
        curr_pgtbl = ((curr_pgtbl[vpn[2]] >> 10) << 12) + PA2VA_OFFSET; // 虚拟地址
        // 处理page middle directory和pgd相似
        if (!(curr_pgtbl[vpn[1]] & 0x1)) { // 如果V bit为0，不存在
            uint64_t *new_pmd = (uint64_t*)(alloc_page() - PA2VA_OFFSET); // 物理地址
            curr_pgtbl[vpn[1]] = (((uint64_t)new_pmd >> 12) << 10 | 0x1);
        }
        // curr_pgtbl = (uint64_t *)((curr_pgtbl[vpn[1]] >> 10) << 12) + PA2VA_OFFSET; //虚拟地址
        curr_pgtbl = ((curr_pgtbl[vpn[1]] >> 10) << 12) + PA2VA_OFFSET; // 虚拟地址
        // 最后是真正的pte
        curr_pgtbl[vpn[0]] = ((curr_pa >> 12) << 10) | perm; // 设置prem，注意pte中存放的永远是物理地址

        curr_pa += PGSIZE;
        curr_va += PGSIZE;
    }
}
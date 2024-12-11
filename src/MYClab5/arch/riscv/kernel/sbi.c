#include "stdint.h"
#include "sbi.h"
#include "printk.h"

struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
    struct sbiret return_val;
    __asm__ volatile (
            "mv a7, %[in_eid]\n"
            "mv a6, %[in_fid]\n"
            "mv a0, %[in_arg0]\n"
            "mv a1, %[in_arg1]\n"
            "mv a2, %[in_arg2]\n"
            "mv a3, %[in_arg3]\n"
            "mv a4, %[in_arg4]\n"
            "mv a5, %[in_arg5]\n"
            "ecall\n"
            "mv %[out_error], a0\n"
            "mv %[out_value], a1\n"
            : [out_error] "=r" (return_val.error), [out_value] "=r" (return_val.value)
            : [in_eid] "r" (eid), [in_fid] "r" (fid), [in_arg0] "r" (arg0),
            [in_arg1] "r" (arg1), [in_arg2] "r" (arg2), [in_arg3] "r" (arg3),
            [in_arg4] "r" (arg4), [in_arg5] "r" (arg5)
            : "memory"
    );
    return return_val;
}

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
    struct sbiret return_val;
    __asm__ volatile(
            "li a7, 0x4442434e\t\n"
            "li a6, 2\n"
            "mv a0, %[byte]\n"
            "ecall\n"
            "mv %[out_error], a0\n"
            "mv %[out_value], a1"
            : [out_error] "=r" (return_val.error), [out_value] "=r" (return_val.value)
            : [byte] "r" (byte)
            : "memory"
            );
    return return_val;
}

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
    struct sbiret return_val;
    __asm__ volatile(
            "li a7, 0x53525354\n"
            "li a6, 0\n"
            "mv a0, %[reset_type]\n"
            "mv a1, %[reset_reason]\n"
            "ecall\n"
            "mv %[out_error], a0\n"
            "mv %[out_value], a1\n"
            : [out_error] "=r" (return_val.error), [out_value] "=r" (return_val.value)
            : [reset_type] "r" (reset_type), [reset_reason] "r" (reset_reason)
            : "memory"
            );
    return return_val;
}

struct sbiret sbi_set_timer(uint64_t stime_value){
    struct sbiret return_val;
    // printk("enter sbi_set_timer\n");
    __asm__ volatile(
            "li a7, 0x54494d45\n"
            "li a6, 0\n"
            "mv a0, %[stime]\n"
            "ecall\n"
            "mv %[out_error], a0\n"
            "mv %[out_value], a1\n"
            : [out_error] "=r" (return_val.error), [out_value] "=r" (return_val.value)
            : [stime] "r" (stime_value)
            : "memory"
            );
    return return_val;
}

struct sbiret sbi_debug_console_write(unsigned long num_bytes, unsigned long base_addr_lo, unsigned long base_addr_hi){
    struct sbiret return_val;
    __asm__ volatile(
            "li a7, 0x4442434e\n"
            "li a6, 0\n"
            "mv a0, %[num_bytes]\n"
            "mv a1, %[addr_lo]\n"
            "mv a2, %[addr_hi]\n"
            "ecall\n"
            "mv %[out_error], a0\n"
            "mv %[out_value], a1\n"
            : [out_error] "=r" (return_val.error), [out_value] "=r" (return_val.value)
            : [num_bytes] "r" (num_bytes), [addr_lo] "r" (base_addr_lo), [addr_hi] "r" (base_addr_hi)
            : "memory"
            );
    return return_val;
}

struct sbiret sbi_debug_console_read(unsigned long num_bytes, unsigned long base_addr_lo, unsigned long base_addr_hi){
    struct sbiret return_val;
    __asm__ volatile(
            "li a7, 0x4442434e\n"
            "li a6, 1\n"
            "mv a0, %[num_bytes]\n"
            "mv a1, %[addr_lo]\n"
            "mv a2, %[addr_hi]\n"
            "ecall\n"
            "mv %[out_error], a0\n"
            "mv %[out_value], a1\n"
            : [out_error] "=r" (return_val.error), [out_value] "=r" (return_val.value)
    : [num_bytes] "r" (num_bytes), [addr_lo] "r" (base_addr_lo), [addr_hi] "r" (base_addr_hi)
    : "memory"
    );
    return return_val;
}
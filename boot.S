.syntax unified
.cpu cortex-m7
.thumb

.global _start
.section .text

/* The Cortex-M Vector Table */
.word 0x24080000      /* 1. Stack Pointer (Top of the 512KB AXI SRAM) */
.word _start + 1      /* 2. Reset Handler (+1 tells the CPU to stay in Thumb mode) */

_start:
    /* Linux expects registers r0, r1, and r2 to be 0 for an appended device tree */
    movs r0, #0
    movs r1, #0
    movs r2, #0

    /* Jump down to the Linux kernel at the 1KB offset */
    ldr r3, =0x08000401
    bx r3
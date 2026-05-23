.syntax unified
.cpu cortex-m7
.thumb

.global _start
.section .text

/* Vector Table */
.word 0x24080000
.word _start + 1

_start:
        cpsid i               /* Disable interrupts */
        movs r0, #0           /* r0 = 0 (Must be 0) */
        ldr r1, =0x00000C16   /* Machine ID for generic ARMv7-M (check arch/arm/tools/mach-types) */
        ldr r2, =0x08000000   /* DTB address (End of your kernel image) */
        add r2, r2, #0x80000  /* Offset to DTB */

        ldr r3, =0x08000401   /* Jump to kernel */
        bx r3
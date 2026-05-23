#!/bin/sh

# The first argument is the target directory.
# We need the BINARIES_DIR, which is usually two levels up from the target.
BINARIES_DIR=$(dirname "$1")/images
BOOT_DIR="board/frostydev/vanguard_v2"

echo "--- Generating Custom XIP Bootloader ---"

# 1. Assemble (Create object file)
output/host/bin/arm-linux-as -mcpu=cortex-m7 -mthumb $BOOT_DIR/boot.S -o $BOOT_DIR/boot.o

# 2. Link (Output to a NEW .elf name)
output/host/bin/arm-linux-ld -Ttext 0x08000000 $BOOT_DIR/boot.o -o $BOOT_DIR/boot.elf

# 3. Extract and Pad to 1024 bytes
output/host/bin/arm-linux-objcopy -O binary $BOOT_DIR/boot.elf $BOOT_DIR/boot.bin
dd if=$BOOT_DIR/boot.bin of=$BOOT_DIR/boot_padded.bin bs=1024 count=1 conv=sync

# 4. Concatenate (Using the correct Binaries directory)
cat $BOOT_DIR/boot_padded.bin $BINARIES_DIR/xipImage $BINARIES_DIR/vanguard_stm32h743.dtb > $BINARIES_DIR/vanguard_final.bin

echo "--- Final Flashable Image: $BINARIES_DIR/vanguard_final.bin ---"
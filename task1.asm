; Write a bootloader in NASM assembly that:

; Sets up the stack.

; Pushes the letters of the word "OSDEV" (in order) onto the stack, one at a time.

; Pops and prints each letter using BIOS (so it appears in reverse: VEDSO).

; Ends with an infinite loop (jmp $).

; Includes the boot sector magic number (0xAA55).
; home work
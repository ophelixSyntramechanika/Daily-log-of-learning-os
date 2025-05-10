; Write a bootloader in NASM assembly that:
; Sets up the stack.
; Pushes the letters of the word "OSDEV" (in order) onto the stack, one at a time.
; Pops and prints each letter using BIOS (so it appears in reverse: VEDSO).
; Ends with an infinite loop (jmp $).
; Includes the boot sector magic number (0xAA55).
; home work

[org 0x7C00]          ; BIOS loads bootloader at 0x7C00
mov ah, 0x0e          ; BIOS teletype print function

; Step 1: Setup the stack
mov bp, 0x8000        ; Set base pointer (safe memory area)
mov sp, bp            ; Set stack pointer

; Step 2: Push letters of "OSDEV"
mov ax, 'O'
push ax
mov ax, 'S'
push ax
mov ax, 'D'
push ax
mov ax, 'E'
push ax
mov ax, 'V'
push ax

; Step 3: Pop and print each letter (prints in reverse: VEDSO)
pop bx
mov al, bl
int 0x10

pop bx
mov al, bl
int 0x10

pop bx
mov al, bl
int 0x10

pop bx
mov al, bl
int 0x10

pop bx
mov al, bl
int 0x10

; Step 4: Hang forever
jmp $

; Step 5: Pad boot sector to 512 bytes and add boot signature
times 510 - ($ - $$) db 0
dw 0xAA55

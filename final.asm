; ===================================================================
; final.asm — Minimal “shell” bootloader (reads one line, handles
;             two commands: “help” and “hello”)
; 
; Assembled with:   nasm -f bin final.asm -o final.bin
; Run in QEMU:     qemu-system-i386 -fda final.bin
; ===================================================================

[org 0x7c00]          ; BIOS loads this at 0x0000:0x7C00

; -----------------------------
; Entry point and main loop
start:
main_loop:
    call print_prompt       ; Show "> "
    call read_input         ; Read one line into [buffer]

    ; -------------------------
    ; Compare user input to "help"
    mov si, buffer          ; SI → start of user input
    mov di, cmd_help        ; DI → the literal "help"
    call strcmp             ; Returns AL=1 if equal, AL=0 if not
    cmp al, 1
    je show_help            ; If AL==1, jump to show_help

    ; -------------------------
    ; Compare user input to "hello"
    mov si, buffer          ; SI → start of user input (again)
    mov di, cmd_hello       ; DI → the literal "hello"
    call strcmp             ; Returns AL=1 if equal
    cmp al, 1
    je show_hello           ; If AL==1, jump to show_hello

    ; -------------------------
    ; If we get here, neither “help” nor “hello” matched
    mov si, msg_unknown
    call print_string
    jmp main_loop

; -----------------------------
; show_help: Print help message, then loop back
show_help:
    mov si, msg_help
    call print_string
    jmp main_loop

; -----------------------------
; show_hello: Print hello message, then loop back
show_hello:
    mov si, msg_hello
    call print_string
    jmp main_loop

; ==================================================================
; Subroutine: print_prompt
;    Prints "> " using BIOS teletype (int 0x10 / AH=0x0E).
; ==================================================================
print_prompt:
    mov ah, 0x0E        ; BIOS teletype mode
    mov al, '>'         ; character '>'
    int 0x10
    mov al, ' '         ; space after '>'
    int 0x10
    ret

; ==================================================================
; Subroutine: read_input
;    Reads keystrokes until ENTER (ASCII 13), converts any 'A'–'Z'
;    to lowercase 'a'–'z', echoes them (int 0x10), and null-terminates.
;    Result: [buffer] = lowercased, null-terminated string.
; ==================================================================
read_input:
    mov si, buffer      ; SI → start of buffer

.read_loop:
    mov ah, 0x00        ; BIOS: wait for keystroke
    int 0x16            ; AL = ASCII code of the key

    cmp al, 13          ; Did the user press ENTER?
    je .done_input

    ; Convert uppercase to lowercase
    cmp al, 'A'
    jb .store_char           ; if AL < 'A', skip conversion
    cmp al, 'Z'
    ja .store_char           ; if AL > 'Z', skip conversion
    add al, 32               ; uppercase → lowercase ('A'→'a', etc.)

.store_char:
    mov [si], al         ; store the character in buffer
    inc si               ; move to next slot in buffer

    ; Echo the character back to the screen
    mov ah, 0x0E
    int 0x10

    jmp .read_loop

.done_input:
    mov byte [si], 0     ; null-terminate the string
    ret

; ==================================================================
; Subroutine: strcmp
;    Compare two null-terminated strings: at [SI] and [DI].
;    Returns AL=1 if they match exactly, AL=0 otherwise.
;    Saves/restores all registers using pusha/popa.
; ==================================================================
strcmp:
    pusha               ; save all registers
.compare_loop:
    lodsb               ; load AL ← [SI]; SI++
    mov bl, al          ; BL = that byte from str1
    lodsb               ; load AL ← [DI]; DI++
    cmp bl, al          ; compare str1_byte vs str2_byte
    jne .not_equal      ; if any difference, jump to not_equal

    cmp bl, 0           ; did we just compare the null terminator?
    jne .compare_loop   ; if not zero, keep looping

    mov al, 1           ; entire string matched (we hit null together)
    popa
    ret

.not_equal:
    xor al, al          ; AL = 0 → strings differ
    popa
    ret

; ==================================================================
; Subroutine: print_string
;    Prints a null-terminated string pointed to by [SI].
;    Uses BIOS teletype (int 0x10 / AH=0x0E). Saves/restores registers.
; ==================================================================
print_string:
    pusha
.print_loop:
    lodsb               ; AL ← [SI]; SI++
    cmp al, 0           ; end-of-string?
    je .done_print
    mov ah, 0x0E
    int 0x10
    jmp .print_loop

.done_print:
    popa
    ret

; ==================================================================
; Data Section
;   buffer:     Where user input is stored (32 bytes + null terminator)
;   cmd_help:   Literal “help”
;   cmd_hello:  Literal “hello”
;   msg_help:   What to print if user typed “help”
;   msg_hello:  What to print if user typed “hello”
;   msg_unknown:What to print if no match
; ==================================================================
buffer       times 32 db 0
cmd_help     db 'help', 0
cmd_hello    db 'hello', 0
msg_help     db 0x0D,0x0A, 'this is help message', 0x0D,0x0A, 0
msg_hello    db 0x0D,0x0A, 'hello user!',         0x0D,0x0A, 0
msg_unknown  db 0x0D,0x0A, 'unknown command',     0x0D,0x0A, 0

; ==================================================================
; Boot Sector Padding & Signature (0xAA55)
;   Fills up to 512 bytes total.
; ==================================================================
times 510 - ($ - $$) db 0
dw 0xAA55

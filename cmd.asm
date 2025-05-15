[org 0x7c00]

start:
    call print_prompt         ; Show "> "
    call read_input           ; Read what user types

    ; Compare input with "help"
    mov si, buffer
    mov di, cmd_help
    call strcmp
    cmp al, 1
    jne hang                  ; If not equal, do nothing

    ; If equal, show message
    mov si, msg_help
    call print_string

hang:
    jmp $                     ; Freeze

; -----------------------------
; print_prompt: Show "> "
print_prompt:
    mov ah, 0x0E
    mov al, '>'
    int 0x10
    mov al, ' '
    int 0x10
    ret

; -----------------------------
; read_input: Type and store into buffer
read_input:
    mov si, buffer
.read_loop:
    mov ah, 0x00
    int 0x16                  ; Wait for keypress, AL = key
    cmp al, 13
    je .done
    mov [si], al              ; Save key to buffer
    inc si
    mov ah, 0x0E
    int 0x10                  ; Echo key to screen
    jmp .read_loop
.done:
    mov byte [si], 0          ; Null-terminate input
    ret

; -----------------------------
; strcmp: Compare string at [SI] with string at [DI]
; Returns AL = 1 if equal, AL = 0 if not
strcmp:
    pusha
.compare_loop:
    lodsb                     ; AL = [SI], SI++
    scasb                     ; Compare AL with [DI], DI++
    jne .not_equal
    cmp al, 0
    jne .compare_loop
    mov al, 1                 ; Match
    popa
    ret
.not_equal:
    mov al, 0                 ; No match
    popa
    ret

; -----------------------------
; print_string: Print null-terminated string from [SI]
print_string:
    pusha
.print_loop:
    lodsb
    cmp al, 0
    je .done
    mov ah, 0x0E
    int 0x10
    jmp .print_loop
.done:
    popa
    ret

; -----------------------------
; Data
buffer     times 32 db 0
cmd_help   db 'help', 0
msg_help   db 0x0D, 0x0A, 'This is the help message.', 0

; Bootloader padding
times 510 - ($ - $$) db 0
dw 0xAA55

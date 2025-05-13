[org 0x7c00]

start:
    mov si, message     ; SI points to start of the string or the stored adress 

print_loop:
    lodsb               ; Load byte at [SI] into AL, and advance SI
    cmp al, 0           ; End of string? (null terminator)
    je hang             ; If yes, stop
    mov ah, 0x0E        ; BIOS teletype
    int 0x10            ; Print AL
    jmp print_loop    ; Repeat

hang:
    jmp $

message db 'HELLO', 0   ; Null-terminated string

times 510 - ($ - $$) db 0
dw 0xAA55

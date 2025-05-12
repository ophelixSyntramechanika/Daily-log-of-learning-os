[org 0x7c00]

start:
    mov bx, 1234
    call print_B
    ; bx is now messed up!

    ; Check with debugging or insert a line here if needed
    jmp $

print_B:
    mov ah, 0x0E
    mov al, 'B'
    int 0x10
    pusha
    popa
    mov bx, 0      ; BAD! Destroys caller's value
    ret

times 510 - ($ - $$) db 0
dw 0xAA55

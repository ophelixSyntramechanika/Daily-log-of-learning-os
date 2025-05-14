[org 0x7c00]

start:
    .loop:
        mov ah,0x00
        int 0x16

        cmp al,13
        je hang

        mov ah,0x0e
        int 0x10

        jmp .loop

    hang:
        jmp $

times 510-($-$$) db 0
dw 0xaa55
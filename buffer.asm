[org 0x7c00]

start:
    mov si,buffer
    .read_loops:
    mov ah,0x00
    int 0x16

    cmp al,13
    je .done

    mov [si],al
    inc si

    mov ah,0x0e
    int 0x10

    jmp .read_loops

.done:
mov byte[si],0
jmp $

buffer times 64 db 0
times 510-($-$$)db 0
dw 0xaa55

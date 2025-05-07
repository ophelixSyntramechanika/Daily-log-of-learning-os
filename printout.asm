[BITS 16]
mov ah,0x0e ; for teletyping in the bios screen and if you ask why i used the h in ah as the h is the higher byte which stores the function code 

    mov al,'h'
    int 0x10

    mov al,'e'
    int 0x10

    mov al,'l'
    int 0x10

    mov al,'l'
    int 0x10

    mov al,'o'
    int 0x10

jmp $

times 510-($-$$) db 0
dw 0xaa55
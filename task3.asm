[ORG 0x7c00]

mov bx,45

cmp bx,10
jb print_low

cmp bx,50
jb print_high

jmp mem

print_low:
mov ah,0x0e
mov al,'L'
int 0x10
jmp hang

print_high:
mov ah,0x0e
mov al,'M'
int 0x10
jmp hang

mem:
mov ah,0x0e
mov al ,'H'
int 0x10
jmp hang

hang:
jmp $

times 510-($-$$) db 0
dw 0xaa55
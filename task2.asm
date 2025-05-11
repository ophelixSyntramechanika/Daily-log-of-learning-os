; Write a boot sector program that:

; Sets bx to 4

; If bx equals 4, print 'E'

; Otherwise, print 'N' (for "Not equal")
[ORG 0x7c00]

mov bx,4
cmp bx,4
je EQUAL
cmp bx,4
jne nutty

EQUAL:
mov ah,0x0e
mov al,'E'
int 0x10
jmp hang

nutty:
mov ah,0x0e
mov al,'n'
int 0x10

hang:
jmp $

times 510-($-$$) db 0
dw 0xaa55

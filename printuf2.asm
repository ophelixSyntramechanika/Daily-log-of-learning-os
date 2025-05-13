[org 0x7c00]

start:
mov si,message
call Print
jmp $

Print:
pusha
lodsb
cmp al,0
je .done
mov ah,0x0e
int 0x10
jmp Print

.done:
popa 
ret

message db 'Welcome',0

times 510-($-$$) db 0
dw 0xaa55


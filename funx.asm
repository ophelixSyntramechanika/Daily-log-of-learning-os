[org 0x7c00]

; start:
; mov al,'h'
; call print_char
; jmp $

; print_char:
; mov ah,0x0e
; int 0x10
; ret 

; start:
; mov al,'A'
; call print
; mov al,'B'
; call print
; mov al,'c'
; call print
; jmp $

; print:
; mov ah,0x0e
; int 0x10
; ret

start:
mov al,'Z'
call print
jmp $

print:
pusha
mov ah,0x0e
int 0x10
popa
ret


times 510-($-$$) db 0
dw 0xaa55
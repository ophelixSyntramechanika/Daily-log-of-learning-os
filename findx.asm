[BITS 16]

mov ah,0x0e

mov al,the_secret
int 0x10

mov al,[the_secret]  ;this line of code works if (org 0x7c00)is written in the code 
int 0x10
;if asked why bx is used then the best general purpose registerimg which is used for memory pinting and referencing and deferncing is bx
mov bx,the_secret    ;the adress of the label is stored in bx
add bx,0x7c00          ;added with the adress 
mov al,[bx]             ;content of the adress is stored in the al 
int 0x10

the_secret:     ;the label is taken and a random address is taken and the x is placed in the adress
db 'x'

times 510-($-$$) db 0
dw 0xaa55
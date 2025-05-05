[BITS 16]               ;its for the bits
[ORG 0x7C00]           ;the adress where the loading of boot loader is done

start:
    mov ah, 0x0E       ; BIOS teletype mode ah holds the function code and the code for teletyping is 0x0E
    mov al, 'H'        ; al holds the ascii character 
    int 0x10           ; print 'H'
    mov al, 'i'
    int 0x10           ; print 'i'

    jmp $              ; infinite loop to prevent bootloader from exiting

times 510 - ($ - $$) db 0 ; pad to 510 bytes (adds 0 until the 514 is not reached as bootloader requires that much)
dw 0xAA55                 ; boot signature (boot loader is genuine code)

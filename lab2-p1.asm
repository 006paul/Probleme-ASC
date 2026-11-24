bits 32
global start
extern exit
import exit msvcrt.dll

segment data use32 class=data
    ; (a+d-c)-(b+b)
    a db 5
    b db 2
    c db 3
    d db 8
segment code use32 class=code
start:
    mov al, [a]
    add al, [d] ; al = a + d
    sub al, [c] ; al = a + d - c
    mov bl, [b]
    add bl, [b] ; bl = b + b
    sub al, bl  ; al = (a+d-c)-(b+b)
    
    push dword 0
    call [exit]
bits 32

global start

extern exit
import exit msvcrt.dll

segment data use32 class=data
    ; a/2+b*b-a*b*c+e+x; a,b,c-byte; e-doubleword; x-qword
    a db 3
    b db -2
    c db -1
    e dd 10
    x dq 12
segment code use32 class=code
    start:
        mov al, [a]     ; al = a
        cbw             ; ax = a
        mov bl, 2       
        idiv bl         ; al = a/2
        
        mov bl, al      ; bl = a/2
        mov al, [b]
        imul byte [b]   ; ax = b*b
        
        mov cx, ax      ; cx = b*b
        mov al, bl      ; al = a/2
        cbw             ; ax = a/2
        add cx, ax      ; cx = a/2 + b*b
        
        mov al, [a]     ; al = a
        imul byte [b]   ; ax = a*b
        mov bx, ax      ; bx = a*b
        mov al, [c]
        cbw             ; ax = c
        imul bx         ; dx:ax = a*b*c
        
        push dx
        push ax
        pop eax         ; eax = a*b*c
        mov ebx, eax    ; ebx = a*b*c
        mov ax, cx      ; ax = a/2 + b*b
        cwde            ; eax = a/2 + b*b
        sub eax, ebx    ; eax = a/2 + b*b - a*b*c
        
        add eax, [e]    ; eax = a/2 + b*b - a*b*c + e
        
        cdq             ; edx:eax = a/2 + b*b - a*b*c + e
        mov ebx, [x]
        mov ecx, [x+4]  ; ecx:ebx = x
        add eax, ebx
        adc edx, ecx    ; edx:eax = a/2+b*b-a*b*c+e+x
        push dword 0
        call [exit]
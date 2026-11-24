bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; (8-a*b*100+c)/d+x; a,b,d-byte; c-doubleword; x-qword
    a db 3
    b db 4
    c dd 5
    d db 2
    x dq 4

; our code starts here
segment code use32 class=code
    start:
        mov al, 100
        imul byte [a] ; ax = a*100
        push ax       ; stiva ax = a*100
        mov al, [b]
        cbw           ; ax = b (word)
        pop bx        ; bx = a*100
        imul word bx  ; dx:ax = a*b*100
        push dx
        push ax       ; stiva dx:ax = a*b*100
        pop eax       ; eax = a*b*100
        mov ebx, 8
        sub dword ebx, eax  ; ebx = 8 - a*b*100
        add ebx, [c]        ; ebx = 8 - a*b*100 + c
        mov al, [d]         ; al = d
        cbw                 ; ax = d
        mov cx, ax          ; cx = d
        push ebx
        pop ax
        pop dx              ; dx:ax = ebx = 8 - a*b*100 + c
        idiv cx             ; ax = (8-a*b*100+c)/d
        cwde                ; eax = 
        cdq                 ; edx:eax = 
        add eax, [x]
        adc edx, [x+4]      ; edx:eax = (8-a*b*100+c)/d+x
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

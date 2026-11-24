bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; (a+b)/(2-b*b+b/c)-x; a-doubleword; b,c-byte; x-qword
    a dd -5
    b db 2
    c db 3
    x dq -14

; our code starts here
segment code use32 class=code
    start:
        mov al, [b]     ; al = b
        cbw             ; ax = b
        cwde            ; eax = b
        add eax, [a]    ; eax = a + b
        push eax        ; stack = a + b
        
        mov al, [b]     ; al = b
        imul byte [b]        ; ax = b * b
        mov bx, 2
        sub bx, ax      ; bx = 2 - b * b
        
        mov al, [b]     ; al = b
        cbw             ; ax = c
        idiv byte [c]   ; al = b / c
        cbw             ; ax = b / c
        add bx, ax      ; bx = 2-b*b+b/c
        
        pop ax         
        pop dx          ; dx:ax = a + b
        
        idiv bx         ; ax = (a+b)/(2-b*b+b/c)
        
        cwde            ; eax = (a+b)/(2-b*b+b/c)
        cdq             ; edx:eax = (a+b)/(2-b*b+b/c)
        mov ebx, [x]
        mov ecx, [x+4]  ; ecx:ebx = x
        
        sub eax, ebx
        sbb edx, ecx    ; edx:eax = (a+b)/(2-b*b+b/c)-x
   
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

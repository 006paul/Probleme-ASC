bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; (e + f)*(2*a + 3*b)
    a db 2
    b db 3
    e dw 5
    f dw 2
; our code starts here
segment code use32 class=code
    start:
        mov al, 2
        mul byte [a] ; ax = 2*a
        mov bx, ax ; bx = 2*a
        mov al, 3
        mul byte [b] ; ax = 3*b
        add ax, bx ; ax = 2*a + 3*b
        mov cx, [e]
        add cx, [f] ; cx = e + f
        mul cx
        
        push dx
        push ax
        pop eax
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

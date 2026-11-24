bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s db "1234",0
    len equ $-s
    d times len dw 0

; our code starts here
segment code use32 class=code
    start:
        mov ecx, len - 1
        sub ecx, 1
        mov esi, 0
        mov edi, 0
        jecxz endfor
        forindex:
            mov eax, 0
            mov al, [s + esi]
            sub al, '0'
            mov bl, [s+ esi + 1]
            sub bl, '0'
            mul bl
            mov [d + edi], ax
            inc esi
            add edi, 2
        loop forindex
        endfor:
            mov eax, [d]
            mov edx, [d + 4]
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

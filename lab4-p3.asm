bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 0001001010100011b
    b dw 1010110000100111b
    c resd 1

; our code starts here
segment code use32 class=code
    start:
        mov ebx, 0
        mov eax, 0
        mov ax, [a]
        and eax, 00007000h
        mov cl, 12
        shr eax, cl
        or ebx, eax ; ebx = ...001
    
        mov eax, 0
        mov ax, [b]
        and eax, 0000003fh
        mov cl, 3
        shl eax, cl
        or ebx, eax ; ebx = ...100111001
    
        mov eax, 0
        mov ax, [a]
        and eax, 000003f8h
        mov cl, 6
        shl eax, cl
        or ebx, eax ; ebx = ...1010100100111001
    
        mov eax, 0
        mov ax, [a]
        mov cl, 16
        shl eax, cl
        or ebx, eax ; ebx = 12a3a939h
        
        mov dword [c], ebx
    
        mov dword [c], ebx
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

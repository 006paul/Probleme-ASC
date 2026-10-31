bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 0100111001011110b
    b dw 1100100011010101b
    c resd 1

    ;bitii 0-4 ai lui C coincid cu bitii 11-15 ai lui A
    ;bitii 5-11 ai lui C au valoarea 1
    ;bitii 12-15 ai lui C coincid cu bitii 8-11 ai lui B
    ;bitii 16-31 ai lui C coincid cu bitii lui A
; our code starts here
segment code use32 class=code
    start:
        mov bx, 0
        
        mov ax, [a]
        and ax, 1111100000000000b
        mov cl, 11
        shr ax, cl
        or bx, ax ; C: 0000000000001001b
        
        or bx, 0000111111100000b ; C: 0000111111101001b
        
        mov ax, [b]
        and ax, 0000111100000000b
        mov cl, 4
        shl ax, cl
        or bx, ax ; C: 1000111111101001b
        
        mov eax, 0
        mov ax, [a]
        mov dx, bx
        mov ebx, 0
        mov cl, 16
        shl eax, cl
        or ebx, eax
        mov bx, dx ; C: 01001110010111101000111111101001b
        mov [c], ebx
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

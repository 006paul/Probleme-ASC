bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 0110110000111110b
    b dw 1001001111010101b
    c resd 1

; our code starts here
segment code use32 class=code
    start:
        mov ebx, 0
        mov eax, 0
        mov ax, [b] ; eax = b
        and eax, 000003c0h
        mov cl, 6
        shr ax, cl
        or ebx, eax ; ebx = ...1110
        
        mov eax, 0
        mov ax, [a] ; eax = a
        and eax, 0000001fh
        mov cl, 4
        shl eax, cl
        or ebx, eax ; ebx = ...111101110
        
        mov eax, 0
        mov ax, [a]
        and eax, 00001fc0h
        mov cl, 3
        shl eax, cl
        or ebx, eax ; ebx = ...0110000111101110
        
        mov eax, 0
        mov ax, [b]
        mov cl, 16
        shl eax, cl
        and eax, 0ffff0000h
        or ebx, eax ; ebx = 93d561ee
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

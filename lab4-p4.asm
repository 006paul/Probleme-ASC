bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 00101101b
    b resb 1
    c resd 1
    n resb 1

; our code starts here
segment code use32 class=code
    start:
        mov bl, 0
        mov al, [a] ; al = 00101101
        and al, 00011100b ; al = 00001101
        mov cl, 2
        shr al, cl ; al = 00000011
        or bl, al ; bl = 00000011
        mov byte [n], bl ; n = 00000011
        mov bl, 0
        mov al, [a] ; al = a
        mov cl, [n] ; cl = 3
        shr al, cl ; al = 00000101
        mov [b], al ; b = 00000101
        
        mov ebx, 0
        mov eax, 0
        mov al, [b] ; eax = b
        mov cl, 16
        shl eax, cl 
        and eax, 00FF0000h ; eax = 
        or ebx, eax ; 23-16 ebx = b
        
        mov eax, 0
        mov al, [a]
        mov cl, 24
        shl eax, cl
        and eax, 0FF000000h
        or ebx, eax ; 31-24 ebx = a, 23-16 ebx = b 15-8 ebx = 0
        
        or ebx, 000000FFh ; 7-0 ebx = 1
        mov dword [c], ebx
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

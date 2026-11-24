bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; (a-b)+(c-b-d)+d - fara semn 5-3 + (10-3-4) + 4 = 2 + 3 + 4 + 9
    a db 5
    b dw 3
    c dd 10
    d dq 4
; our code starts here
segment code use32 class=code
    start:
        mov al, [a]
        mov ah, 0 ; ax = a
        sub ax, [b] ; ax = a-b
        mov ebx, 0
        mov bx, [b] ; ebx = b
        mov ecx, [c]
        sub ecx, ebx ; ecx = c - b
        mov ebx, 0 ; ebx:ecx = c - b
        sub dword ecx, [d]
        sbb dword ebx, [d+4] ; ebx:ecx = c-b-d
        mov dx, ax ; dx = a-b
        mov eax, 0
        mov ax, dx ; eax = a-b
        mov edx, 0 ; edx:eax = a-b
        add eax, ecx
        adc edx, ebx ; edx:eax = (a-b)+(c-b-d)
        add eax, [d]
        adc edx, [d+4] ; edx:eax = (a-b)+(c-b-d)+d
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

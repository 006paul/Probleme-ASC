bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf,fopen, fclose, fread, fscanf , fprintf             ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll
import fscanf msvcrt.dll
import fprintf msvcrt.dll   ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    descriptor dd -1
    descriptor_new dd -1
    mod_acces db "r", 0
    mod_acces_new db "w", 0
    fisier db "input.txt", 0
    msg_sume db "sumele partiale: ", 0
    new_file times 100 db 0
    len equ 100
    a times (len+1) dd 0
    b times (len+1) dd 0
    n dd 0
    temp dd 0
    p1 dd 0
    p2 dd 0
    
    format db "%d ", 0
    format_in db "%d", 0
    format_new_file db "%s", 0
    format_perechi db " %d %d", 0
    format_new_file_out db "%d ", 10, 0
    newline db 10, 0
    

; our code starts here
segment code use32 class=code
    start:
        push dword mod_acces
        push dword fisier
        call [fopen]
        add esp, 4 * 2
        
        mov [descriptor], eax
        
        cmp eax, 0
        je final
        mov esi, 0
        
    citire:
        push dword temp
        push dword format_in
        push dword [descriptor]
        call [fscanf]
        add esp, 4 * 3
        
        cmp eax, 1
        jne gata_citire
        mov eax, [temp]
        
        cmp eax, 0
        je gata_citire
        mov [a + esi * 4], eax
        inc esi
        jmp citire
        
    gata_citire:
        mov [n], esi
        
        push dword [descriptor]
        call [fclose]
        add esp, 4
        
        mov ecx, [n]
        mov esi, 0
        
        xor eax, eax
    sume_partiale:
        add eax, [a + 4 * esi]
        mov [b + 4 * esi], eax
        inc esi
        loop sume_partiale
        
        push dword msg_sume
        call [printf]
        add esp, 4
        
        mov ecx, [n]
        mov esi, 0
    afisare:
        push ecx
        mov eax, [b + 4 * esi]
        push eax
        push dword format
        call [printf]
        add esp, 4 * 2
        
        pop ecx
        inc esi
        loop afisare
        
        push dword newline
        push dword format_new_file
        call [printf]
        add esp, 4 * 2
        
        push dword new_file
        push dword format_new_file
        call [scanf]
        add esp, 4 * 2
        
        push dword mod_acces_new
        push dword new_file
        call [fopen]
        add esp, 4 * 2
        mov [descriptor_new], eax
    
    citire_perechi:
        push dword p2
        push dword p1
        push dword format_perechi
        call [scanf]
        add esp, 4 * 3
        
        cmp eax, 2
        jne final
        mov eax, [p1]
        cmp eax, [p2]
        jne compara
        cmp dword [p1], -1
        je final
        
    compara:
        cmp eax, [p2]
        jg citire_perechi
        cmp eax, 0
        jl citire_perechi
        mov ebx, [p2]
        cmp [n], ebx
        jle citire_perechi
        
        
    prelucrare_perechi:
        mov ecx, [p2]
        sub ecx, [p1]
        add ecx, 1
        mov esi, [p1]
        xor eax, eax
    suma:
        add eax, [a + esi * 4]
        inc esi
        loop suma
        push eax
        push dword format_new_file_out
        push dword [descriptor_new]
        call [fprintf]
        add esp, 4 * 3
        jmp citire_perechi
    final:
        push dword [descriptor_new]
        call [fclose]
        add esp, 4
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

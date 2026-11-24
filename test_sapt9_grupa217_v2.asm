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
    descriptor_out dd -1
    mod_acces dd "r", 0
    mod_acces_out dd "w", 0
    fisier_in db "input1.txt", 0
    fisier_out times 100 db 0
    
    len equ 100                 
    n dd 0
    s times (len + 1) db 0
    nrv times 5 dd 0
    v db "aeiou", 0
    nu_exista db 'nu exista', 0
    ; nrv      = nr_a
    ; nrv +  4 = nr_e
    ; nrv +  8 = nr_i
    ; nrv + 12 = nr_o
    ; nrb + 16 = nr_u
    
    format_citire db "%s", 0
    format_fisier_nou db "%s", 0
    format_maxim db "%d ", 10, 0
    format_vocala db "%c ", 0

; our code starts here
segment code use32 class=code
    start:
        push dword mod_acces
        push dword fisier_in
        call [fopen]                ; deschidem fisierul input1.txt
        add esp, 4 * 2
        mov [descriptor], eax
    
        push dword [descriptor]
        push dword len
        push dword 1
        push dword s
        call [fread]                ; citim textul din fisier si il salvam in s
        add esp, 4 * 4
        
        mov [n], eax                ; salvam in variabila n numarul de caractere al sirului
        
        push dword [descriptor]     ; inchidem fisierul input1.txt
        call [fclose]   
        add esp, 4
        
        mov ecx, [n]                ; initializam contorul
        mov esi, 0                  ; initializam indexul
        
    numara_vocale:
        mov al, [s + esi]           ; luam caracterul curent

        ; Verificam A / a
        cmp al, 'a'
        je inc_a
        cmp al, 'A'
        je inc_a

        ; Verificam E / e
        cmp al, 'e'
        je inc_e
        cmp al, 'E'
        je inc_e

        ; Verificam I / i
        cmp al, 'i'
        je inc_i
        cmp al, 'I'
        je inc_i

        ; Verificam O / o
        cmp al, 'o'
        je inc_o
        cmp al, 'O'
        je inc_o

        ; Verificam U / u
        cmp al, 'u'
        je inc_u
        cmp al, 'U'
        je inc_u

        jmp urmatorul_caracter  
    inc_a:
        add dword [nrv], 1
        jmp urmatorul_caracter
    inc_e:
        add dword [nrv + 4], 1
        jmp urmatorul_caracter
    inc_i:
        add dword [nrv + 8], 1
        jmp urmatorul_caracter
    inc_o:
        add dword [nrv + 12], 1
        jmp urmatorul_caracter
    inc_u:
        add dword [nrv + 16], 1
        
    urmatorul_caracter:
        inc esi
        loop numara_vocale
        
        mov ecx, 4
        mov eax, [nrv]
        mov esi, 4
    maxim:                          ; cautam maximul de aparitii al unei vocale
        cmp eax, [nrv + esi]
        jae urmatorul
        mov eax, [nrv + esi]
    urmatorul:
        add esi, 4
        loop maxim
        mov ebx, eax                ; ebx = maxim
        
        push dword fisier_out       ; citim numele noului fisier
        push dword format_fisier_nou
        call [scanf]
        add esp, 4 * 2
        
        push dword mod_acces_out    ; deschidem fisierul pentru output
        push dword fisier_out
        call [fopen]
        add esp, 4 * 2
        mov [descriptor_out], eax
        
        cmp ebx, 0
        je negasit
        
        push ebx                    ; scriem maximul in fisierul de output
        push dword format_maxim
        push dword [descriptor_out]
        call [fprintf]
        add esp, 4 * 3
        
        cmp [nrv], ebx
        jne verif_e
        push dword 'a'
        push dword format_vocala
        push dword [descriptor_out]
        call [fprintf]
        add esp, 4 * 3
    verif_e:
        cmp [nrv + 4], ebx
        jne verif_i
        push dword 'e'
        push dword format_vocala
        push dword [descriptor_out]
        call [fprintf]
        add esp, 4 * 3
    verif_i:
        cmp [nrv + 8], ebx
        jne verif_o
        push dword 'i'
        push dword format_vocala
        push dword [descriptor_out]
        call [fprintf]
        add esp, 4 * 3
    verif_o:
        cmp [nrv + 12], ebx
        jne verif_u
        push dword 'o'
        push dword format_vocala
        push dword [descriptor_out]
        call [fprintf]
        add esp, 4 * 3
    verif_u:
        cmp [nrv + 16], ebx
        jne final
        push dword 'u'
        push dword format_vocala
        push dword [descriptor_out]
        call [fprintf]
        add esp, 4 * 3
        jmp final
    negasit:
        push dword nu_exista
        push dword format_vocala
        push dword [descriptor_out]
        call [fprintf]
        add esp, 4 * 3
    final:
        push dword [descriptor_out]     ; inchidem fisierul de output
        call [fclose]
        add esp, 4
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

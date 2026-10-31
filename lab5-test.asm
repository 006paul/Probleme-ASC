bits 32 
global start        
extern exit
import exit msvcrt.dll
                          
segment data use32 class=data
	; signed representation
    	; x/2+100*(a+b)-3/(c+d)+e*e = 225 = E1h; a,c-word; b,d-byte; e-doubleword; x-qword
        ; 20/2+100*(1+1)-3/(2+1)+4*4
	a dw 1
	c dw 2
	
	b db 1
	d db 1
	
	e dd 4
	x dq 20
    
; our code starts here
segment code use32 class=code
    start:
		; x/2+100*(a+b)-3/(c+d)+e*e; a,c-word; b,d-byte; e-doubleword; x-qword
		mov AL, [b]         ; al = b
		cbw                 ; ax = b
		add AX, [a]         ; ax = a + b
		mov BX, 100         ; bl = 100
		imul BX             ; dx:ax = 100*(a+b)
		push DX
		push AX      
		mov AL, [d]         ; al = d
		cbw                 ; ax = d
		add AX, [c]         ; ax = c + d
		mov BX, AX          ; bx = c + d
		mov AX, 3   
		cwd                 ; dx:ax = 3
		idiv BX             ; ax = 3/(c+d)
		cwde                ; eax = 3/(c+d)
		pop EBX             ; ebx = 100*(a+b)
		sub EBX, EAX        ; ebx = 100*(a+b)-3/(c+d)
		push EBX    
		mov EAX, [x]
		mov EDX, [x + 4]    ; edx:eax = x
        mov ebx, 2
		idiv ebx            ; eax = x/2
		pop ECX             ; ecx = 100*(a+b)-3/(c+d)
		add EAX, ECX        ; eax = x/2+100*(a+b)-3/(c+d)
		cdq                 ; edx:eax = x/2+100*(a+b)-3/(c+d)       
		push EDX 
		push EAX
		mov EAX, [e]        ; eax = e
		imul dword [e]      ; edx:eax = e*e
		pop ebx
        pop ecx             ; ecx:ebx = x/2+100*(a+b)-3/(c+d) 
		add EAX, EBX
		adc EDX, ECX        ; edx:eax = x/2+100*(a+b)-3/(c+d)+e*e
		
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
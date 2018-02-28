; OS423 Master Boot Record Sector
; ver07 -- cls by int 10 ah=1
; 2/12/2018

	;bit16					; 16bit by default
	org 0x7c00
	jmp short start
	nop
bsOEM	db "OS423 v.0.3"               ; OEM String

;==========================================================;
;        cls is done via int 10h, ah=1                     ;
;==========================================================;

start:
	mov  ax,cs
	mov  ds,ax
	mov  es,ax
	call install_syscall10 	;implment user defined interrupt
	call install_syscallff	;implment user defined interrupt

	mov  ah, 06h	;service ah=1
	; set parameters

	mov ch, ''	;char to display
	mov cl, 0ah	;yellow on green
	int  10h	;interrupt call

	mov ah, 0
	int 16h		;wait for keyboard

	mov  ah, 01h	;service ah=1
	; set parameters

	mov bl, 2fh		;color
	mov cx, mlen
	lea bp, [msg]
	int 0xff

	int 20h


install_syscall10:
	push dx
	push es				;backup
	
	xor ax, ax
	mov es, ax			;es set to segment 0000
	cli				;disable interrupt
	mov word [es:0x10*4], _int0x10	;interrupt 0x10
	mov [es:0x10*4+2], cs		;table entry
	sti				;enable interrupt
	
	pop es
	pop dx				;restore

    ret

install_syscallff:
	push dx
	push es				;backup
	
	xor ax, ax
	mov es, ax			;es set to segment 0000
	cli					;disable interrupt
	mov word [es:0xff*4], _int0xff	;interrupt 0x10
	mov [es:0xff*4+2], cs		;table entry
	sti				;enable interrupt
	
	pop es
	pop dx				;restore

    ret

;==========================================================;
;                 Interrupt Service ffh                    ;
;==========================================================;

_int0xff:
	pusha				;save all
	cmp ah,0x01			;service ah=1
	je  _int0xff_ser0x01
	jmp _int0xff_end		;done

;==========================================================;
;	Interrupt Service ffh ah=0x01			   ;
;	ch=char to display cl=color attr		   ;
;==========================================================;

_int0xff_ser0x01:

	; Service code here

print:

	mov al, bl		;save color
	mov bx,0xb800	;direct video memory access 0xB8000
	mov es,bx
	xor bx,bx
				
.loop:
	mov ah, byte [ds:bp]

;==========================================================
; 'Virus' - convert lowercase to uppercase
;==========================================================

	;a (97) -- z (122)
	;A (65) -- Z (90)
	
	cmp ah, 58
	jl .addOne

	cmp ah, 'a'
	jl .notHigher
	
	cmp ah, 'z'
	jg .notLower
	
	.notLower:
	add ah, 'A'-'a'
	jmp .virusEnd

	.notHigher:
	add ah, 'a'-'A'
	jmp .virusEnd

	.addOne:
	cmp ah, 48
	jl .virusEnd
	cmp ah, 57
	je .nine
	add ah, 1
	jmp .virusEnd

	.nine
	add ah, -9
	jmp .virusEnd

	.virusEnd:

;==========================================================
; End Virus
;==========================================================

	mov byte [es:bx], ah	;char
	inc bx
	mov byte [es:bx], al	;attribute 
	inc bx

.next:	
	inc bp
	dec cx
	jne .loop		

	msg db 'Hello 423'
	mlen equ $-msg		


	jmp _int0xff_end		;done

;==========================================================
; Done
;==========================================================

_int0xff_end:
	popa				;restore
	iret				;must use iret instead ret

;==========================================================;
;                 Interrupt Service 10h                    ;
;==========================================================;

_int0x10:
	pusha					;save all
	cmp ah,0x06			;service ah= 06h
	je  _int0x10_ser0x06	;Jump to function _int0x10_ser0x06
	jmp _int0x10_end		;done

;==========================================================;
;	Interrupt Service 10h ah=0x06			   ;
;	ch=char to display cl=color attr		   ;
;==========================================================;

_int0x10_ser0x06:

	; Service code here

cls:
	mov bx,0xb800		;direct video memory access 0xB8000
	mov es,bx
	xor bx,bx		;es:bx : 0xb8000
	mov dh,0		;row from 0 to 24
	mov dl,0		;col from 0 to 79
		
.loop:
	mov byte [es:bx], ch	;char
	inc bx
	mov byte [es:bx], cl	;attribute 
	inc bx

.next:		
	inc dl
	cmp dl,80		;col 0-79
	jne .loop
	mov dl,0
	inc dh
	cmp dh, 24		;row 0-4
	jne .loop	

	jmp _int0x10_end		;done

;==========================================================
; Done
;==========================================================

_int0x10_end:
	popa				;restore
	iret				;must use iret instead ret

	
padding	times 510-($-$$) db 0		;to make MBR 512 bytes
bootSig	db 0x55, 0xaa		;signature (optional)
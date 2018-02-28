; Gillian Lemke
; E01445800

  	org 0x7c00
 	 jmp short start
  	nop
bsOEM db "OS423 v.0.3"	; OEM String

start:
	mov ah, 06h	; function 06h (scroll screen)
	mov al, 0		; scroll all lines
	mov bh, 0ah	; attribute (lightgreen on black)
  	mov ch, 0		; upper left row is zero
  	mov cl, 0		; upper left column is zero
  	mov dh, 24	; lower left row is 24
  	mov dl, 79 		; lower left column is 79
  	int 10h			; BIOS interrupt 10h (video services)

  	mov ah, 13h	; function 13h (display string), XT machine only
  	mov al, 1		; write mode is zero: cursor stay after last char
  	mov bh, 0		; use video page of zero
  	mov bl, 0ah	; attribute (lightgreen on black)
  	mov cx, mlen	; character string length
  	mov dh, 0		; position on row 0
  	mov dl, 0		; and column 0
  	lea bp, [msg]	; load the offset address of string into BP, es:bp
					; same as mov bp, msg
  	int 10h			; BIOS interrupt 10h (video services)

;ctrl-c
keyin:
	mov ah, 0
	int 16h
	cmp ax, 0x2e03
	cmp ax, 0x2004
	jne keyin


; display string without using BIOS int 10h
displayWithoutBios:
  	mov ax, 3					; set VGA mode (text)
  	int 0x10

  	mov dx, 0xB800			; beginning of display memory
 	mov es, dx		

  	mov si, TextHelloWorld 	; point si at the string 

  	mov cx, 0
  	ForEachChar:		  		; begin loop
    		lodsb					; load al with [si], increment si
    		cmp al, 0x00	   			; if char is null
    		je EndForEachChar 		; then break out of the loop

    		mov di, cx				; offset of current character

    		mov [es:di], al			; write the character to memory

    		inc cx					; there are two bytes per character
		inc cx					; so increment cx twice

		jmp ForEachChar	   	; jump back to beginning of loop
  	EndForEachChar:	   	; end of the loop

keyinvisual:
	mov ah, 0
	int 16h
	cmp ax, 0x2e03
	cmp ax, 0x2004
	jne keyinvisual

mov bx,0xb800		;direct video memory access 0xB8000
mov es,bx
xor bx,bx				;es:bx : 0xb8000
mov dh,0				;row from 0 to 24
mov dl,0				;col from 0 to 79
		
.loop:
	mov byte [es:bx], 207h	;char
	inc bx
	mov byte [es:bx], 8ah		;attribute 
	inc bx

.next:		
	inc dl
	cmp dl,80					;col 0-80
	jne .loop
	mov dl,0
	inc dh
	cmp dh,25					;rows
	jne .loop

mov ah,41h 
mov dx,filename 
int 21h 

ret


; data values
msg db 'Hello 423 by Gillian Lemke'
mlen equ $-msg
TextHelloWorld: db 'Hello 423 by Gillian Lemke ',0
filename db "a.img",0

; 512 and 55aa
padding	times 510-($-$$) db 0		;to make MBR 512 bytes
bootSig	db 0x55, 0xaa		;signature (optional)
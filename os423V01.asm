
;;cls
	mov ah,06h		;Function 06h (scroll screen)
	mov al,0		        ;Scroll all lines
	mov bh,75h		
	mov ch,0		        ;Upper left row is zero
	mov cl,0			;Upper left column is zero
	mov dh,24		;Lower left row is 24
	mov dl,79		;Lower left column is 79
	int 10h			;BIOS Interrupt 10h (video services)
				


	;bit16			;16bit by default
	org 0x7c00		;use as .com 

	jmp short start
	nop
	bsOEM	db "OS423 v.0.1"               ; OEM String

start:

	mov ah,13h		;Function 13h (display string), XT machine only
	mov al,1		;Write mode is zero: cursor stay after last char
	mov bh,0		;Use video page of zero
	mov bl,72h		;Attribute (blue on gray)
	mov cx,mlen2		;Character string length
	mov dh,10		;Position on row 0
	mov dl,1		;And column 0
	lea bp,[msg2]	;Load the offset address of string into BP, es:bp
	int 10h

	mov ah, 2		;set cursor location
	mov bh, 0		;page=0
	mov dh, 0		;row, 0..24
	mov dl, 0		;col, 0..79
	int 10h

	mov ah, 09h		;write a char and attribute
	mov al, 0c9h		;char to display
	mov bh, 0		        ;page=0		
	mov bl, 75h		
	mov cx, 1			;repetitions 
	int 10h
	inc dl


print:
	mov ah, 2		;set cursor location
	mov bh, 0		;page=0
	mov dh, 0		;row, 0..24
	;mov dl, 0		;col, 0..79
	int 10h

	mov ah, 09h		;write a char and attribute
	mov al, 0cdh		;char to display
	mov bh, 0		        ;page=0		
	mov bl, 75h		
	mov cx, cx			;repetitions 
	int 10h

	inc cx
	inc dl
	cmp cx, 29h
	jne print

	;int 20h

mov ah, 2		;set cursor location
mov bh, 0		;page=0
mov dh, 0		;row, 0..24
mov dl, 79		;col, 0..79
int 10h

mov ah, 09h		;write a char and attribute
mov al, 0bbh		;char to display
mov bh, 0		        ;page=0		
mov bl, 75h		
mov cx, 1			;repetitions 
int 10h
mov dh, 1
mov dl, 79
mov bp, 0
int 10h

printRight:
	mov ah, 2		;set cursor location
	mov bh, 0		;page=0
	;mov dh, 1		;row, 0..24
	mov dl, 79		;col, 0..79
	int 10h

	mov ah, 09h		;write a char and attribute
	mov al, 0bah		;char to display
	;mov bh, 0		        ;page=0		
	mov bl, 75h		
	mov cx, 1			;repetitions 
	int 10h

	inc bp
	inc dh
	cmp bp, 18h
	jne printRight


mov ah, 2		;set cursor location
mov bh, 0		;page=0
mov dh, 24	;row, 0..24
mov dl, 79		;col, 0..79
int 10h

mov ah, 09h		;write a char and attribute
mov al, 0bch		;char to display
mov bh, 0		        ;page=0		
mov bl, 75h		
mov cx, 1			;repetitions 
int 10h
mov dh, 24
mov dl, 1
mov bp, 0
int 10h

printBottom:
	mov ah, 2		;set cursor location
	mov bh, 0		;page=0
	mov dh, 24	;row, 0..24
	;mov dl, 79	;col, 0..79
	int 10h

	mov ah, 09h		;write a char and attribute
	mov al, 0cdh		;char to display
	;mov bh, 0		        ;page=0		
	mov bl, 75h		
	mov cx, 1			;repetitions 
	int 10h

	inc bp
	inc dl
	cmp bp, 4eh
	jne printBottom

mov ah, 2		;set cursor location
mov bh, 0		;page=0
mov dh, 24	;row, 0..24
mov dl, 0		;col, 0..79
int 10h

mov ah, 09h		;write a char and attribute
mov al, 0c8h		;char to display
mov bh, 0		        ;page=0		
mov bl, 75h		
mov cx, 1			;repetitions 
int 10h
mov dh, 1
mov dl, 0
mov bp, 0
int 10h

printLeft:
	mov ah, 2		;set cursor location
	mov bh, 0		;page=0
	;mov dh, 24	;row, 0..24
	mov dl, 0		;col, 0..79
	int 10h

	mov ah, 09h		;write a char and attribute
	mov al, 0bah		;char to display
	;mov bh, 0		        ;page=0		
	mov bl, 75h		
	mov cx, 1			;repetitions 
	int 10h

	inc bp
	inc dh
	cmp bp, 17h
	jne printLeft

mov ah,13h		;Function 13h (display string), XT machine only
mov al,1		;Write mode is zero: cursor stay after last char
mov bh,0		;Use video page of zero
mov bl,71h		;Attribute (blue on gray)
mov cx,mlen		;Character string length
mov dh,1		;Position on row 0
mov dl,1		;And column 0
lea bp,[msg]	;Load the offset address of string into BP, es:bp
int 10h

mov ah, 10h
int 16h
cmp al, 0dh

xor cx,cx
mov dh,19h
mov dl,50h
mov bh,7
mov ax,700h
int 10h

mov ah,13h		;Function 13h (display string), XT machine only
mov al,1		;Write mode is zero: cursor stay after last char
mov bh,0		;Use video page of zero
mov bl,0dh
mov cx,mlen4		;Character string length
mov dh,0		;Position on row 0
mov dl,0		;And column 0
lea bp,[msg4]	;Load the offset address of string into BP, es:bp
int 10h

int 20h
	

msg db 'GLOS, Gillian Lemke, version 0.1, current 0.1 2018 $'
mlen equ $-msg

msg2 db '  ___ _    ___  ___ ',10,13,'  / __| |  / _ \/ __|',10,13,' | (_ | |_| (_) \__ \',10,13,'  \___|____\___/|___/'
mlen2 equ $-msg2

;msg3 db '   _   __',10,13,'      (_\-`  `.',10,13,'         `---`',10,13
msg3 db ''
mlen3 equ $-msg3

msg4 db '$'
mlen4 equ $-msg4

padding	times 510-($-$$) db 0		;to make MBR 512 bytes
bootSig	db 0x55, 0xaa		;signature (optional)




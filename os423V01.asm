
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
	;org 0x100		;use as .com 

	jmp short start
	;nop

start:
	;mov al, 0c9h
	;mov dl,  0

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

int 20h


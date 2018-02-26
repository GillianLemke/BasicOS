; Gillian Lemke
; E01445800

  org 0x7c00
  jmp short start
  nop
bsOEM db "OS423 v.0.3"	; OEM String

start:
  ; code to set up IVT
  
  mov ah, 06h	; function 06h (scroll screen)
  mov al, 0		; scroll all lines
  mov bh, 0ah	; attribute (lightgreen on black)
  mov ch, 0		; upper left row is zero
  mov cl, 0		; upper left column is zero
  mov dh, 24	; lower left row is 24
  mov dl, 79 	; lower left column is 79
  int 10h		; BIOS interrupt 10h (video services)

  mov ah, 13h	; function 13h (display string), XT machine only
  mov al, 1		; write mode is zero: cursor stay after last char
  mov bh, 0		; use video page of zero
  mov bl, 0ah	; attribute (lightgreen on black)
  mov cx, mlen	; character string length
  mov dh, 0		; position on row 0
  mov dl, 0		; and column 0
  lea bp, [msg]	; load the offset address of string into BP, es:bp
				; same as mov bp, msg
  int 10h		; BIOS interrupt 10h (video services)

  ; optional extra display or others
  ; code to lad 2nd sector to 0001:2345 and execute
  ; 512 and 55aa


msg db 'Hello 423 by Gillian Lemke'
mlen equ $-msg
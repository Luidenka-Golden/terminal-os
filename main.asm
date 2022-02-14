	org 0x7c00
	bits 16

	mov ax, 0
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7c00

	mov ah, 0x00
	mov al, 0x03  ; text mode 80x25 16 colours
	int 0x10

	mov si, welcome 
	call print_string

	mainloop:
	mov si, prompt
	call print_string

	mov di, buffer
	call get_string

	mov si, buffer
	cmp byte [si], 0
	je mainloop

	mov si, 

	mov si, badcommand
	call print_string
	jmp mainloop

	
	
	welcome db  'Golden Terminal OS',13,10,'Version 0.75 (C) Copyright Luidenka, 2022',13,10,0
	buffer times 64 db 0
	prompt db '>>>', 0
	badcommand db 'Bad command', 0x0d, 0x0a, 0
	cmd_date db 'date', 0
	cmd_time db 'time', 0
	cmd_copy db 'copy', 0
	cmd_dir db 'dir', 0
	cmd_erase db 'erase', 0
	cmd_pause db 'pause', 0
	cmd_rem db 'rem', 0
	cmd_rename db 'rename', 0
	cmd_type db 'type', 0
	date:
		db "Current date is: "
    	db "00-00-0000", 0dh, 0ah
	time:
		db "Current time is: "
		db "00:00:00", 0dh, 0ah, '$'




	print_string:
	lodsb
	or al, al
	jz .done 
	
	mov ah, 0x0e
	int 0x10

	jmp print_string


	.done:
	ret

	get_string:
	xor cl, cl
	.loop:
	mov ah, 0
	int 0x16

	cmp al, 0x08
	je .backspace
	
	cmp al, 0x0D
	je .done
	
	cmp cl, 0x3F
	je .loop
	
	mov ah, 0x0e
	int 0x10

	stosb
	inc cl
	jmp .loop

	.backspace:
		cmp cl, 0
		je .loop

		dec di
		mov byte [di], 0
		dec cl
		
		mov ah, 0x0e
		mov al, 0x08
		int 0x10

		mov al, ' '
		int 0x10

		mov al, 0x08
		int 0x10

		jmp .loop

		.done:
		mov al,0
		stosb
		
		mov ah, 0x0e
		mov al, 0x0d
		int 0x10
		mov al, 0x0a
		int 0x10

		ret

	strcmp:
	.loop:
	mov al, [si]
	mov bl, [di]
	cmp al, bl
	jne .notequal

	cmp al, 0
	je .done

	inc di
	inc si

	jmp .loop

	.notequal:
	clc
	ret
	.done:
		stc
		ret

	times 510-($-$$) db 0
	dw 0xaa55

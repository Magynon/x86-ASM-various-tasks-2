section .text
	global par

par:
	push	ebp
	push	esp
	pop		ebp
	sub		esp, 2

	push 	dword [ebp + 8]
	pop		ecx						; str_length
	push 	dword [ebp + 12]
	pop		esi						; str

	xor		ebx, ebx
	xor		edx, edx

string_loop:
	push	dword [esi]
	pop		eax
	shl		eax, 24
	shr		eax, 24

	cmp		eax, 0x28
	je		incOpen				; if char is open par -> increment opened paranthesis counter

	inc		ebx					; else increment closed paranthesis counter

pickupPoint:
	inc		esi					; go to next paranthesis
	loop	string_loop
	jmp		check

incOpen:
	inc		edx
	jmp		pickupPoint

check:
	cmp		edx, ebx			; check if string is valid
	je		returnTrue

	xor		eax, eax
	jmp 	end_par

returnTrue:
	xor		eax, eax
	inc		eax

end_par:
	push	ebp
	pop		esp
	pop		ebp

	ret

section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b
cmmmc:
	push    ebp
    mov     ebp, esp
    pusha

	push 	dword [ebp + 8]
	pop		ecx						; a
	push 	dword [ebp + 12]
	pop		esi						; b

greatestDenominator:				; compute greatest denominator
	cmp		ecx, 0					; check if a is 0
	je		printB

	cmp		esi, 0					; check if b is 0
	je		printA

	cmp		esi, ecx				; check if a = b
	je		printA

	cmp		ecx, esi				; check if a > b
	jg		aBiggerThanb

bBiggerThana:
	sub		esi, ecx				; b = b - a
	jmp		greatestDenominator

aBiggerThanb:
	sub		ecx, esi				; a = a - b
	jmp		greatestDenominator

printB:
	push	esi						; push greatest denominator
	jmp		end

printA:
	push	ecx						; push greatest denominator
	jmp		end

end:
	push 	dword [ebp + 8]
	pop		eax						; a
	push 	dword [ebp + 12]
	pop		ecx						; b

	pop		ebx						; pop greatest denominator
	mul		ecx						; eax = a x b
	div		ebx						; eax = a x b / greatest denominator
	
	push	ebp
	pop		esp
	pop		ebp

	ret

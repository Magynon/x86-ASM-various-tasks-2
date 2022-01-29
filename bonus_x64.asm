section .text
	global intertwine
	extern printf

section .data
    message: db "hey!", 0

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	enter 0, 0

	;; rdi, rsi, rdx, rcx, r8
	;;  v1,  n1,  v2,  n2,  v
	xor		rax, rax						;; intialize array traversal index
	xor		rbx, rbx						;; intialize toggle (0 / 1)

while:
	cmp		rsi, 0							;; while n1 and n2 are both > 0
	je      restFromV2
	cmp		rcx, 0
	je		restFromV1

	cmp		rbx, 0							;; check toggle to determine which array to copy from
	je		addFromV1						;; if toggle = 0, copy from V1

	mov		r10, [rdx]						;; if toggle = 1, get value from v2[rax] in r10
	mov		[r8], r10						;; move value to v[rax]
	mov		rbx, 0							;; toggle the toggle :)
	dec		rcx								;; decrement index in V2 to check when reached end
	add 	rdx, 4							;; increment indexes
	add		r8, 4

	jmp		while

addFromV1:
	mov		r10, [rdi]						;; get value from v1[rax] in r10
	mov		[r8], r10						;; move value to v[rax]
	mov		rbx, 1							;; toggle the toggle :)
	dec		rsi								;; decrement index in V1 to check when reached end
	add 	rdi, 4							;; increment indexes
	add		r8, 4

	jmp		while

restFromV2:
	mov		r10, [rdx]						;; get value from v2[rax] in r10
	mov		[r8], r10						;; move value to v[rax]
	add		rdx, 4							;; increment indexes
	add		r8, 4
	loop	restFromV2						;; loop while end of array not reached
	jmp		end

restFromV1:
	cmp		rsi, 0
	je		end
	
	mov		r10, [rdi]						;; get value from v1[rax] in r10
	mov		[r8], r10						;; move value to v[rax]
	add		rdi, 4
	add		r8, 4							;; increment indexes
	dec		rsi
	jmp		restFromV1						;; loop while end of array not reached

end:

	leave
	ret

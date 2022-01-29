section .text
	global sort

section .data
	temp_var:	dd 0

; struct node {
;     	int val;
;    	struct node* next;
; };
;; struct node* sort(int n, struct node* node);

sort:
	push    ebp
    mov     ebp, esp
    pusha

	mov     ecx, [ebp + 8]			; no. of nodes
	mov		esi, [ebp + 12]			; address of first element

	;PRINTF32 `Number of nodes: %d\n\x0`, ecx

	;PRINTF32 `Current node to add: %d\n\x0`, [esi]
	mov		eax, esi				; add the first node as head of list
	
nextNodeInArray:
	dec		ecx						; decrement node count
	cmp		ecx, 0					; see if no nodes are left for addition
	je		end						; if so, end program

	add		esi, 8					; if not, go to next node in array

addNodeFunction:
	;PRINTF32 `Current node to add: %d\n\x0`, [esi]
	mov		ebx, [esi]				; move current node's value in ebx
	cmp		[eax], ebx				; compare head of list with current node
	jg		insertAsFirstNode		; if head is greater, insert current node as first node
	mov		edx, eax				; if not, use edx as a list visitor, starting from head..
	xor		edi, edi

traverseList:						; ..and traverse list until finding node with NULL as next address (*)
	cmp		edi, 0					; check if it's the first time entering the traversal
	jne		incrCounter				; if so, do not increment counter this time

pickupPoint:
	cmp		[edx+4], dword 0		; (*) here
	je		insertAsLastNode

	mov		edi, [edx+4]			; increment list cursor
	cmp		[edi], ebx 				; ..or until finding a lower NEXT value than the current one
	;PRINTF32 `Compare %d with %d\n\x0`, [edi], ebx
	jl		traverseList			; (always checking one node ahead, to make the moving fast)

insertAsInteriorNode:
	;PRINTF32 `Insert interior\n\x0`
	push	dword [edx+4]			; remember current-node-in-list's next address
	mov		[edx+4], esi			; update current-node-in-list's next address
	pop		dword [esi+4]			; update current-node-to-add's next address

	jmp		nextNodeInArray

insertAsFirstNode:
	;PRINTF32 `Insert first\n\x0`
	mov		[esi+4], eax			; move head of list address into current node's NEXT address
	mov		eax, esi				; make current node the head of the list

	mov		edi, [esi+4]
	;PRINTF32 `%d arata catre %d\n\x0`, [eax], [edi]

	jmp		nextNodeInArray

insertAsLastNode:
	;PRINTF32 `Insert last\n\x0`
	mov		[edx+4], esi			; move current node's address into former tail of list
	jmp		nextNodeInArray

incrCounter:
	mov		edx, [edx+4]
	jmp		pickupPoint

end:
	leave
	ret

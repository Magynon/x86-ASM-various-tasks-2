section .text

	global cpu_manufact_id
	global features
	global l2_cache_info

;; void cpu_manufact_id(char *id_string);
;
;  reads the manufacturer id string from cpuid and stores it in id_string
cpu_manufact_id:	
	enter 	0, 0
	mov		edi, [ebp + 8]

	push	dword ebx		;; push for cdecl reasons
	push	dword edx
	push	dword ecx

	mov		eax, 0
	cpuid

	mov		[edi], ebx		;; copy chars from each reg to the string memory location
	add		edi, 4
	mov		[edi], edx
	add		edi, 4
	mov		[edi], ecx

	pop		ecx				;; pop for cdecl reasons
	pop		edx
	pop		ebx

	leave
	ret

;; void features(char *vmx, char *rdrand, char *avx)
;
;  checks whether vmx, rdrand and avx are supported by the cpu
;  if a feature is supported, 1 is written in the corresponding variable
;  0 is written otherwise
features:
	enter 	0, 0

	push	dword ebx		;; push for cdecl reasons
	push	dword edx
	push	dword ecx

	mov		eax, dword 1
	cpuid

check_vmx:
	mov		eax, [ebp + 8]
	mov		[eax], dword 0	;; set to 0 just in case not true
	mov		ebx, ecx
	shr		ebx, 5			;; vmx bit
	and		ebx, 1			;; check bit
	jnz		vmx_true

check_avx:
	mov		eax, [ebp + 16]
	mov		[eax], dword 0	;; set to 0 just in case not true
	mov		ebx, ecx
	shr		ebx, 28			;; avx bit
	and		ebx, 1			;; check bit
	jnz		avx_true

check_rdrand:
	mov		eax, [ebp + 12]
	mov		[eax], dword 0	;; set to 0 just in case not true
	mov		ebx, ecx
	shr		ebx, 30			;; rdrand bit
	and		ebx, 1			;; check bit
	jnz		rdrand_true
	
end:
	pop		ecx				;; pop for cdecl reasons
	pop		edx
	pop		ebx

	leave
	ret

vmx_true:
	mov		[eax], dword 1	;; set to 1 if true
	jmp		check_avx

avx_true:
	mov		[eax], dword 1	;; set to 1 if true
	jmp		check_rdrand

rdrand_true:
	mov		[eax], dword 1	;; set to 1 if true
	jmp		end

;; void l2_cache_info(int *line_size, int *cache_size)
;
;  reads from cpuid the cache line size, and total cache size for the current
;  cpu, and stores them in the corresponding parameters
l2_cache_info:
	enter 	0, 0

	push	dword ebx		;; push for cdecl reasons
	push	dword edx
	push	dword ecx

	mov		eax, 80000006h	;; eax value to output required information
	cpuid

	push	dword ecx		;; save ecx value
	and		ecx, 0xff		;; obtain cache line size (first 8 bits)
	mov		eax, [ebp + 8]	;; get required var's address
	mov		[eax], ecx		;; move to required var

	pop		ecx
	shr		ecx, 16
	and		ecx, 0xffff		;; obtain total cache size (last 16 bits)
	mov		eax, [ebp + 12]	;; get required var's address
	mov		[eax], ecx		;; move to required var

	pop		ecx				;; pop for cdecl reasons
	pop		edx
	pop		ebx
	
	leave
	ret

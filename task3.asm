global get_words
global compare_func
global sort

section .data
    delim: db " ,.", 10, 0

section .text
    extern strtok
    extern strcmp
    extern qsort
    extern strlen

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
compare_func:
    enter 0, 0

    mov     eax, [ebp + 8]
    mov     eax, [eax]

    push    dword eax
    call    strlen              ;; find the length of the first string
    add     esp, 4
    push    dword eax           ;; save it for later in the stack

    mov     eax, [ebp + 12]
    mov     eax, [eax]

    push    dword eax
    call    strlen              ;; find the length of the second string
    add     esp, 4

    pop     ebx                 ;; restore length of first string from stack

    cmp     eax, ebx            ;; compare the two lengths
    jne     cmp_by_length       ;; if they are not equal, comparison is made by length

cmp_by_lexic:                   ;; if not, comparison is made in lexicographical way
    mov     eax, [ebp + 12]
    mov     eax, [eax]
    push    dword eax           ;; push the beginning of the first string to the stack

    mov     eax, [ebp + 8]
    mov     eax, [eax]
    push    dword eax           ;; push the beginning of the second string to the stack

    call    strcmp              ;; return lexicographical order
    add     esp, 8
    jmp     end

cmp_by_length:
    jg      first_greater       ;; if first one is greater, return 1
    mov     eax, 1              ;; else return -1
    jmp     end

first_greater:
    mov     eax, -1

end:
    leave
    ret

sort:
    enter 0, 0

    push    compare_func            ;; compare function
    push    dword [ebp + 16]        ;; size of word
    push    dword [ebp + 12]        ;; number of words
    push    dword [ebp + 8]         ;; array of words
    call    qsort                   ;; call qsort to sort the input array
    add     esp, 16

    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0

    mov     esi, [ebp + 8]              ;; string
    mov     ebx, [ebp + 12]             ;; words
    mov     ecx, [ebp + 16]             ;; no of words

word_loop:
    push    dword ecx                   ;; will be reset while executing strtok

    push    dword delim
    push    dword esi
    call    strtok                      ;; call strtok to separate text
    add     esp, 8

    pop     ecx                         ;; restore ecx to make loop functional
    xor     esi, esi                    ;; make esi NULL

    mov     [ebx], eax                  ;; add current string to the string array
    add     ebx, 4                      ;; increment array pointer by size of a pointer

    loop word_loop

    leave
    ret

section .data
    extern malloc

section .bss
    vigenereSquare resb 26 * 26

section .text
global populateMatrix

populateMatrix:
    push    rbp
    mov     rbp, rsp
    push    rbx
    sub     rsp, 40
    mov     edi, 208
    call    malloc
    mov     QWORD [rbp-32], rax ; Corrected memory reference syntax
    mov     DWORD [rbp-20], 0
    jmp     .L2

.L5:
        mov     eax, DWORD [rbp-20] ; Corrected memory reference syntax
        cdqe
        lea     rdx, [0+rax*8]
        mov     rax, QWORD [rbp-32]
        lea     rbx, [rdx+rax]
        mov     edi, 26
        call    malloc
        mov     QWORD [rbx], rax ; Corrected memory reference syntax
        mov     DWORD [rbp-24], 0
        jmp     .L3
.L4:
        mov     edx, DWORD [rbp-20] ; Corrected memory reference syntax
        mov     eax, DWORD [rbp-24] ; Corrected memory reference syntax
        add     eax, edx
        mov     rdx, rax
        imul    rdx, rdx, 1321528399
        shr     rdx, 32
        sar     edx, 3
        mov     ecx, eax
        sar     ecx, 31
        sub     edx, ecx
        mov     DWORD [rbp-36], edx ; Corrected memory reference syntax
        mov     edx, DWORD [rbp-36] ; Corrected memory reference syntax
        imul    edx, edx, 26
        sub     eax, edx
        mov     DWORD [rbp-36], eax ; Corrected memory reference syntax
        mov     eax, DWORD [rbp-36] ; Corrected memory reference syntax
        lea     ecx, [rax+65]
        mov     eax, DWORD [rbp-20] ; Corrected memory reference syntax
        cdqe
        lea     rdx, [0+rax*8]
        mov     rax, QWORD [rbp-32] ; Corrected memory reference syntax
        add     rax, rdx
        mov     rdx, QWORD [rax] ; Corrected memory reference syntax
        mov     eax, DWORD [rbp-24] ; Corrected memory reference syntax
        cdqe
        add     rax, rdx
        mov     edx, ecx
        mov     BYTE [rax], dl ; Corrected memory reference syntax
        add     DWORD [rbp-24], 1
.L3:
        cmp     DWORD [rbp-24], 25
        jle     .L4
        add     DWORD [rbp-20], 1
.L2:
    cmp     DWORD [rbp-20], 25
    jle     .L5
    mov     rax, QWORD [rbp-32] ; Corrected memory reference syntax
    lea     rdx, [vigenereSquare]
    mov     ecx, 84
    mov     rdi, rdx
    mov     rsi, rax
    rep movsq
    mov     rax, rsi
    mov     rdx, rdi
    mov     ecx, DWORD [rax] ; Corrected memory reference syntax
    mov     DWORD [rdx], ecx ; Corrected memory reference syntax
    nop
    mov     rbx, QWORD [rbp-8]
    leave
    ret

section .note.GNU-stack
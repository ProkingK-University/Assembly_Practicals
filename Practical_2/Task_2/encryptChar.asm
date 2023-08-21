encryptChar:
        push    rbp
        mov     rbp, rsp
        mov     QWORD PTR [rbp-24], rdi
        mov     ecx, esi
        mov     eax, edx
        mov     edx, ecx
        mov     BYTE PTR [rbp-28], dl
        mov     BYTE PTR [rbp-32], al
        movsx   eax, BYTE PTR [rbp-28]
        sub     eax, 65
        mov     DWORD PTR [rbp-4], eax
        movsx   eax, BYTE PTR [rbp-32]
        sub     eax, 65
        mov     DWORD PTR [rbp-8], eax
        mov     eax, DWORD PTR [rbp-4]
        cdqe
        lea     rdx, [0+rax*8]
        mov     rax, QWORD PTR [rbp-24]
        add     rax, rdx
        mov     rdx, QWORD PTR [rax]
        mov     eax, DWORD PTR [rbp-8]
        cdqe
        add     rax, rdx
        movzx   eax, BYTE PTR [rax]
        pop     rbp
        ret
removeSpaces:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     QWORD PTR [rbp-24], rdi
        mov     rax, QWORD PTR [rbp-24]
        mov     rdi, rax
        call    strlen
        mov     DWORD PTR [rbp-12], eax
        mov     DWORD PTR [rbp-4], 0
        mov     DWORD PTR [rbp-8], 0
        jmp     .L4
.L6:
        mov     eax, DWORD PTR [rbp-8]
        movsx   rdx, eax
        mov     rax, QWORD PTR [rbp-24]
        add     rax, rdx
        movzx   eax, BYTE PTR [rax]
        movzx   eax, al
        mov     edi, eax
        call    isspace
        test    eax, eax
        jne     .L5
        mov     eax, DWORD PTR [rbp-8]
        movsx   rdx, eax
        mov     rax, QWORD PTR [rbp-24]
        lea     rcx, [rdx+rax]
        mov     eax, DWORD PTR [rbp-4]
        lea     edx, [rax+1]
        mov     DWORD PTR [rbp-4], edx
        movsx   rdx, eax
        mov     rax, QWORD PTR [rbp-24]
        add     rdx, rax
        movzx   eax, BYTE PTR [rcx]
        mov     BYTE PTR [rdx], al
.L5:
        add     DWORD PTR [rbp-8], 1
.L4:
        mov     eax, DWORD PTR [rbp-8]
        cmp     eax, DWORD PTR [rbp-12]
        jl      .L6
        mov     eax, DWORD PTR [rbp-4]
        movsx   rdx, eax
        mov     rax, QWORD PTR [rbp-24]
        add     rax, rdx
        mov     BYTE PTR [rax], 0
        nop
        leave
        ret
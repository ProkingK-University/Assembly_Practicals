; External function declarations
extern malloc
extern strlen
extern encryptChar

section .text
    global encryptString

encryptString:
    ; Function prologue
    push    rbp
    mov     rbp, rsp
    sub     rsp, 64         ; Allocate space on the stack

    ; Store function parameters on the stack
    mov     QWORD [rbp-40], rdi  ; Store vigenereSquare
    mov     QWORD [rbp-48], rdx  ; Store keyword
    mov     QWORD [rbp-56], rsi  ; Store plaintext

    ; Get the lengths of the keyword and plaintext
    mov     rax, QWORD [rbp-48]
    mov     rdi, rax
    call    strlen
    mov     DWORD [rbp-8], eax   ; Store keywordLength
    mov     rax, QWORD [rbp-56]
    mov     rdi, rax
    call    strlen
    mov     DWORD [rbp-12], eax  ; Store plaintextLength

    ; Allocate memory for the encrypted text
    mov     eax, DWORD [rbp-12]
    add     eax, 1
    cdqe
    mov     rdi, rax
    call    malloc
    mov     QWORD [rbp-24], rax  ; Store encryptedText pointer

    mov     DWORD [rbp-4], 0     ; Initialize loop counter

    jmp     .check_size  ; Jump to the loop start

.encrypt_loop:
    ; Loop body
    mov     eax, DWORD [rbp-4]
    cdq
    idiv    DWORD [rbp-8]
    mov     eax, edx
    movsxd   rdx, eax

    ; Calculate the position in keyword and plaintext
    mov     rax, QWORD [rbp-48]
    add     rax, rdx
    movzx   eax, BYTE [rax]
    mov     BYTE [rbp-25], al

    mov     eax, DWORD [rbp-4]
    movsxd   rdx, eax
    mov     rax, QWORD [rbp-56]
    add     rax, rdx
    movzx   eax, BYTE [rax]
    mov     BYTE [rbp-26], al

    ; Encrypt the characters using encryptChar function
    movsx   edx, BYTE [rbp-26]
    movsx   ecx, BYTE [rbp-25]
    mov     rax, QWORD [rbp-40]
    mov     esi, ecx
    mov     rdi, rax
    mov     eax, 0
    call    encryptChar
    mov     ecx, eax

    ; Store the encrypted character in encryptedText
    mov     eax, DWORD [rbp-4]
    movsxd   rdx, eax
    mov     rax, QWORD [rbp-24]
    add     rax, rdx
    mov     edx, ecx
    mov     BYTE [rax], dl

    add     DWORD [rbp-4], 1   ; Increment loop counter

.check_size:
    mov     eax, DWORD [rbp-4]
    cmp     eax, DWORD [rbp-12]
    jl      .encrypt_loop  ; Jump to loop body if the condition is true

    ; Null-terminate the encrypted text
    mov     eax, DWORD [rbp-12]
    movsxd   rdx, eax
    mov     rax, QWORD [rbp-24]
    add     rax, rdx
    mov     BYTE [rax], 0

    mov     rax, QWORD [rbp-24]

    ; Function epilogue
    leave
    ret
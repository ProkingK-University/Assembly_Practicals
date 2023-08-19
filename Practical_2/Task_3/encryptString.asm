extern  encryptChar
extern  populateMatrix

global  encryptString

section .text

encryptString:
    push rbp                                ; save the base pointer
    mov rbp, rsp                            ; set the base pointer
    sub rsp, 32                             ; allocate space on stack

    mov qword [rbp-24], rdi                 ; save vigenereSquare
    mov qword [rbp-32], rsi                 ; save keyword
    mov qword [rbp-40], rdx                 ; save plaintext

    ; get keywork length
    xor eax, eax                            ; clear eax
    mov rdi, qword [rbp-32]                 ; set rdi to point to keyword

    .getKeywordLength:
        cmp BYTE [rdi], 0                   ; compare character to the null
        je .saveKeyword                     ; if character is null, save
        inc eax                             ; increment the length counter
        inc rdi                             ; move to the next character
        jmp .getKeywordLength               ; repeat the loop
    .saveKeyword:
        mov dword [rbp-4], eax              ; save length

    ; get plaintext length
    xor eax, eax                            ; clear eax
    mov rdi, qword [rbp-40]                 ; set rdi to point to plaintext

    .getPlaintextLength:
        cmp BYTE [rdi], 0                   ; compare character to the null
        je .savePlaintext                   ; if character is null, save
        inc eax                             ; increment the length counter
        inc rdi                             ; move to the next character
        jmp .getPlaintextLength             ; repeat the loop
    .savePlaintext:
        mov dword [rbp-8], eax              ; save length

    ; allocate memory for encrypted text
    add dword [rbp-8], 1                    ; add 1 for null terminator
    lea rax, [rbp-48]                       ; calculate amount of space
    sub rsp, rax                            ; allocate space on stack

    ; encrypt string
    mov dword [rbp-12], 0                   ; initialize loop counter i to 0

    .loop:
        cmp dword [rbp-12], dword [rbp-8]   ;compare loop counter i with plaintextLength
        jge .endLoop                        ; if i >= plaintextLength, jump to .loopEnd

        ; get keyword character
        mov eax, dword [rbp-12]             ; set eax to i
        cdq                                 ; sign extend eax into edx:eax
        idiv dword [rbp-4]                  ; divide edx:eax by keywordLength, quotient in eax and remainder in edx
        mov eax, edx                        ; set eax to remainder (i % keywordLength)
        cdqe                                ; sign extend eax into rax
        add rax, qword [rbp-32]             ; add address of keyword string to rax
        movzx eax, BYTE [rax]               ; load character at address in rax into al and zero extend into eax
        mov BYTE [rbp-17], al               ; save character in local variable

        ; get plaintext character
        mov eax, dword [rbp-12]             ; set eax to i
        cdqe                                ; sign extend eax into rax 
        add rax, qword [rbp-40]             ; add address of plaintext string to rax 
        movzx eax, BYTE [rax]               ; load character at address in rax into al and zero extend into eax 
        mov BYTE [rbp-18], al               ; save character in local variable 

        ; get encrypted character
        lea rdx, [rbp-18]                   ; load address of plaintextChar into rdx 
        lea rsi, [rbp-17]                   ; load address of keywordChar into rsi 
        mov rdi, qword [rbp-24]             ; load vigenereSquare into rdi 
        call encryptChar                    ; call the encryptChar function
        mov edx, dword [rbp-12]             ; 
        lea rcx, [rbp+rax*1+48]             ;
        add rcx, rdx                        ;
        mov BYTE [rcx], al                  ;
        add dword [rbp-12], 1               ; increment loop counter i
        jmp .loop                           ; repeat the loop

    .endLoop:
        ; add null terminator
        xor eax, eax                       ; set eax to 0
        cdqe                               ; sign extend eax into rax
        add rax, qword [rbp+48]            ; add address of encryptedText to rax
        add rax, qword [rbp+8]             ; add plaintextLength to rax
        mov BYTE [rax], 0                  ; set null terminator

    ; return encryptedText;
    lea rax, [rbp+48]                  ; load address of encryptedText into rax
    leave                              ; restore the stack and base pointers
    ret                                ; return from the function
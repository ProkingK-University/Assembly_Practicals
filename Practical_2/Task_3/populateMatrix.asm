extern malloc

section .data
    vigenereSquare: dq 0

section .text
    global populateMatrix

populateMatrix:
    ; allocate memory for vigenereSquare
    push rbp
    mov rbp, rsp
    mov rdi, 26 * 8
    call malloc
    mov [vigenereSquare], rax

    ; initialize loop counter i to 0
    xor r12, r12

    outer_loop:
        ; check if i < 26
        cmp r12, 26
        jge end_outer_loop

        ; allocate memory for vigenereSquare[i]
        mov rdi, 26
        call malloc

        ; store pointer in vigenereSquare[i]
        mov rbx, [vigenereSquare]
        mov [rbx + r12 * 8], rax

        ; initialize loop counter j to 0
        xor r13, r13

    inner_loop:
        ; check if j < 26
        cmp r13, 26
        jge end_inner_loop

        ; calculate (i + j) % 26 + 'A'
        mov rax, r12
        add rax, r13
        xor rdx, rdx
        mov rcx, 26
        div rcx
        add rdx, 'A'

        ; store result in vigenereSquare[i][j]
        mov rbx, [vigenereSquare]
        mov rcx, [rbx + r12 * 8]
        mov [rcx + r13], rdx

        ; increment j and jump to start of inner_loop
        inc r13
        jmp inner_loop

    end_inner_loop:
        ; increment i and jump to start of outer_loop
        inc r12
        jmp outer_loop

    end_outer_loop:
        ; return vigenereSquare
        mov rax, [vigenereSquare]
    
    end:
    pop rbp
    ret
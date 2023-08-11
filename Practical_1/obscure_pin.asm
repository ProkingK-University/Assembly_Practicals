section .data
    pin db 5           ; 4 digits + null terminator
    prompt db "Enter 4-digit PIN: ", 0
    format_in db "%s", 0
    format_out db "Obfuscated PIN: %s", 10, "Reversed PIN: %s", 10, 0

section .bss
    input resb 5

section .text
main:
    push rbp
    mov rbp, rsp

    xor eax, eax

.reverse_loop:
    movzx ecx, byte [rdi + rax]
    sub ecx, '0'
    xor ecx, 0xF
    add ecx, '0'
    mov [rdi + rax], cl
    inc rax
    cmp rax, 4
    jl .reverse_loop

    ret



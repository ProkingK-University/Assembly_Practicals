extern malloc
extern strcpy

section .data
    name db "Calvin", 0
    address db "12 Mockingbird Lane",0
    balance dd 125

    struc Customer
        c_id resd 1
        align 4
        c_name resb 71
        align 1
        c_address resb 71
        align 1
        c_balance resd 1
        align 4
    endstruc

    c dq 0 ; to hold a Customer pointer

section .text
    global getTest

getTest:
    push rbp
    mov rbp, rsp
    push rbx

    mov rdi, 160
    call malloc
    mov [c], rax ; save the pointer

    mov edx, dword [balance]
    mov [rax+c_balance], edx
    
    mov [rax+c_id], dword 7

    lea rdi, [rax+c_name]
    lea rsi, [name]
    call strcpy
    mov rax, [c] ; restore the pointer

    lea rdi, [rax+c_address]
    lea rsi, [address]
    call strcpy
    mov rax, [c] ; restore the pointer


    leave
    ret
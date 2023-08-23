section .text
    global encryptChar

encryptChar:
    ; Prologue: Function setup
    push    rbp                 ; Save the previous base pointer
    mov     rbp, rsp            ; Set the current stack frame as base pointer
    
    ; Store function arguments on the stack
    mov     QWORD [rbp-24], rdi ; Store vigenereSquare pointer in local variable
    mov     ecx, esi            ; Copy keywordChar to ecx (row index)
    mov     eax, edx            ; Copy plaintextChar to eax (column index)
    
    ; Calculate the intersection row and column indices
    mov     edx, ecx            ; Copy row index to edx
    mov     BYTE [rbp-28], dl   ; Store lower 8 bits of edx as row index
    mov     BYTE [rbp-32], al   ; Store lower 8 bits of eax as column index
    
    ; Extract ASCII values and adjust to [0-25] range
    movsx   eax, BYTE [rbp-28]  ; Sign-extend row index
    sub     eax, 65             ; Adjust to [0-25] range ('A' is ASCII 65)
    mov     DWORD [rbp-4], eax  ; Store adjusted row index
    
    movsx   eax, BYTE [rbp-32]  ; Sign-extend column index
    sub     eax, 65             ; Adjust to [0-25] range ('A' is ASCII 65)
    mov     DWORD [rbp-8], eax  ; Store adjusted column index
    
    ; Calculate array indices
    mov     eax, DWORD [rbp-4]  ; Load adjusted row index to eax
    cdqe                        ; Convert to 64-bit value (rax) for addressing
    lea     rdx, [0+rax*8]      ; Calculate offset for row index
    
    mov     rax, QWORD [rbp-24] ; Load vigenereSquare pointer to rax
    add     rax, rdx            ; Add row index offset to the pointer
    mov     rdx, QWORD [rax]    ; Load the row array pointer
    
    mov     eax, DWORD [rbp-8]  ; Load adjusted column index to eax
    cdqe                        ; Convert to 64-bit value (rax) for addressing
    add     rax, rdx            ; Add column index offset to the row array pointer
    
    ; Load the encrypted character from the Vigenère Square
    movzx   eax, BYTE [rax]     ; Load the byte at the calculated address
    
    ; Epilogue: Clean up and return
    pop     rbp                 ; Restore the previous base pointer
    ret                         ; Return with the result in eax
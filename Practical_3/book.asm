extern malloc
extern strcpy

section .data
    struc Book
        isbn resb 13
        title resb 50
        price resd 1
        quantity resd 1
    endstruc

    book dq 0

section .text
    global allocateBook

allocateBook:
    push    rbp            ; Save the base pointer
    mov     rbp, rsp       ; Set up the new base pointer
    sub     rsp, 48        ; Allocate space on the stack for local variables

    ; Store function arguments in local variables
    mov     qword [rbp-24], rdi    ; isbn
    mov     qword [rbp-32], rsi    ; title
    movss   dword [rbp-36], xmm0   ; price
    mov     dword [rbp-40], edx    ; quantity

    ; Call malloc to allocate memory for the Book structure
    mov     rdi, 71        ; Size to allocate
    call    malloc         ; Allocate memory
    mov     [book], rax    ; Store the memory address in the 'book' variable

    ; Copy isbn to the Book struct
    mov     rdi, rax             ; Destination (address of Book)
    mov     rsi, qword [rbp-24]  ; Source (address of isbn)
    call    strcpy
    mov     rax, [book]

    ; Copy title to the Book struct
    lea     rdx, [rax+13]           ; Calculate the destination address for title
    mov     rdi, rdx                ; Destination (address of Book.title)
    mov     rsi, qword [rbp-32]     ; Source (address of title)
    call    strcpy
    mov     rax, [book]
    
    ; Copy price to the Book struct
    movss   xmm0, dword [rbp-36]    ; Load price into xmm0
    movss   dword [rax+64], xmm0    ; Copy price to Book.price
    mov     rax, [book]

    ; Copy quantity to the Book struct
    mov     edx, dword [rbp-40]     ; Load quantity
    mov     dword [rax+68], edx     ; Copy quantity to Book.quantity

    ; Prepare the return value (address of the Book struct)
    mov     rax, [book]

    leave
    ret
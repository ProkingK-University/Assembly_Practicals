extern malloc
extern memset
extern strcmp
extern strcpy

section .data
    library dq 0

section .text
    global addBook
    global searchBookByISBN
    global initialiseLibrary

initialiseLibrary:
    push    rbp        ; Save base pointer
    mov     rbp, rsp   ; Set base pointer
    sub     rsp, 16    ; Allocate 16 bytes for locals

    mov     rdi, 364   ; Set size argument for malloc
    call    malloc     ; Allocate memory and store result in rax
    mov [library], rax ; Save malloc result in 'library'

    mov     rdi, rax   ; Set destination for memset to 'library'
    mov     rsi, 0     ; Set value to 0
    mov     rdx, 360   ; Set size for memset
    call    memset     ; Initialize memory block with zeros

    mov     rax, [library]  ; Load 'library' address into rax

    mov    dword [rax+360], 0  ; Set 'count' field of Library to 0
    mov     rax, [library]     ; Load 'library' address into rax

    leave
    ret

addBook:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32

    ; Initialize r12 and r13 with function arguments
    mov     r12, rdi
    mov     r13, rsi

    ; Loop through the books array
    mov     rbx, 0              ; Initialize counter (ecx) to 0
    loop_start:
        ; Compare ISBN of current book
        imul    rbx, 72
        lea     rdi, [r12+rbx]
        lea     rsi, [r13]
        call    strcmp
        cmp     eax, 0
        je      book_exists
        inc     rbx
        cmp     rbx, [r12+360]
        jl      loop_start

        ; Check if the library is full
    cmp     dword [r12+360], 5
    je      fail_end

    ; Copy ISBN
    mov     ecx, dword [r12+360]
    imul    rcx, 72
    lea     rax, [r12+rcx]
    lea     rdi, [rax]
    lea     rsi, [r13]
    call    strcpy

    ; Copy Title
    mov     ecx, dword [r12+360]
    imul    rcx, 72
    lea     rax, [r12+rcx]
    lea     rdi, [rax+13]
    lea     rsi, [r13+13]
    call    strcpy

    ; Copy the price
    mov     ecx, dword [r12+360]
    imul    rcx, 72
    mov     eax, dword [r13+64]
    lea     rdx, [r12+rcx]
    mov     dword [rdx+64], eax

    ; Copy the quantity
    mov     ecx, dword [r12+360]
    imul    rcx, 72
    mov     eax, dword [r13+68]
    lea     rdx, [r12+rcx]
    mov     dword [rdx+68], eax

    ; Increment the book count in the library
    inc     dword [r12+360]

    ; Jump to success_end
    jmp     success_end

book_exists:
    ; Add the quantity of the new book to the existing book
    mov     eax, dword [r13+68]
    lea     rdx, [r12+rbx]
    add     dword [rdx+68], eax

success_end:
    mov     eax, 1
    leave
    ret

fail_end:
    mov     eax, 0
    leave
    ret

searchBookByISBN:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32

    ; Initialize r12 and r13 with function arguments
    mov     r12, rdi
    mov     r13, rsi

    ; Check if the library is empty
    cmp     dword [r12+360], 0
    je      not_found

    ; Loop through the books array
    mov     rbx, 0              ; Initialize counter (ecx) to 0
    mov     r14, 0

    search:
        ; Compare ISBN with books in libary
        imul    rbx, r14, 72
        lea     rdi, [r12+rbx]
        lea     rsi, [r13]
        call    strcmp
        cmp     eax, 0
        je      found
        inc     r14
        cmp     r14, [r12+360]
        jle      search

    not_found:
        mov     eax, 0  ;return null
        leave
        ret

    found:
        lea     rax, [r12+rbx] ; return book
        leave
        ret
extern malloc
extern memset

section .data
    library dq 0

section .text
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
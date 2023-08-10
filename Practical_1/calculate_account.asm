; This makes your function available to other files
global calculate_account

section .data
  text db 'Your account number is:',10
  textLen equ $ - text

section .bss
  asciiNumber resb 20         ; Space for ASCII digits (adjust size as needed)

section .text
  calculate_account:

  push rbp                    ; Save base pointer onto stack
  mov rbp, rsp                ; Set base pointer to current value on the stack

  ; Print the "Your account number is: " message

  mov rax, 1                  ; syscall number for sys_write
  mov rdi, 1                  ; file descriptor 1 (stdout)
  mov rsi, text               ; message address
  mov rdx, textLen            ; message length
  syscall

  ; Add 10000 to pin to get the account number

  mov rax, rdi               ; Move the pin value to rax register
  add rax, 10000              ; Add 10000 to rax register

  leave
  ret
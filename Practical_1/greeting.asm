; This makes your function available to other files
global greeting

section .data
; ==========================
; Your data goes here
  texts db 'Welcome to the Bank of <<Redacted>>',10
  textLen equ $ - texts
; ==========================

section .text

; void greeting()
; This function prints a greeting to the screen
greeting:
  push rbp
  mov rbp, rsp
; Do not modify anything above this line unless you know what you are doing
; ==========================
; Your code goes here
  mov rax, 1
  mov rdi, 1
  mov rsi, texts
  mov rdx, textLen
  syscall
; ==========================
; Do not modify anything below this line unless you know what you are doing
  leave
  ret
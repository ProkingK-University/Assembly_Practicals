global calculate_balance

section .text
; Calculate balance based on account number and pin
; Inputs:
;   rdi - account number
;   rsi - pin
; Outputs:
;   rax - balance
calculate_balance:
  push rbp
  mov rbp, rsp

  ; Get account number (A) and pin (P)
  mov rax, rdi ; rax = A
  mov rbx, rsi ; rbx = P

  ; Calculate B'
  add rax, rbx       ; A + P
  imul rax, rbx      ; (A + P) * P
  xor rax, rdi       ; (A + P) * P ^ (P xor A)

  ; Calculate B
  mov rdx, 0          ; clear rdx
  div qword 50000     ; rax / 50000
  add rax, 50000      ; add 50000
  
  leave
  ret
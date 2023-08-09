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
  mov rax, rdi          ; rax = A

  ; Calculate B'
  add rax, rsi          ; A + P
  mul rsi               ; (A + P) * P
  mov rcx, rsi          ; rcx = P
  xor rcx, rdi          ; (P xor A)
  and rax, rcx          ; (A + P) * P ^ (P xor A)

  ; Calculate B
  mov rbx, 50000        ; rbx = 50000
  mov rdx, 0            ; clear rdx
  div rbx               ; rax / 50000
  mov rax, rdx          ; rax = remainder
  add rax, 50000        ; add 50000
  
  leave
  ret
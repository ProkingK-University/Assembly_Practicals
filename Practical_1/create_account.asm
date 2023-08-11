; This tells the function that these exist outside of this file
extern  get_pin
extern  greeting
extern  obscure_pin
extern  calculate_balance
extern  calculate_account

; This makes your function available to other files
global  create_account

section .data
; ==========================
; Your data goes here
  acc_ptr     dq 0
  pin_ptr     dq 0
  bal_ptr     dq 0
  acc_num     dq 0
  pin_val     dq 0
; ==========================

section .text
; void create_account(char *account_number, char *obscured_pin, char *balance)
;
; Inputs:
;   rdi - account number
;   rsi - pin
;   rdx - balance
;
create_account:
  push rbp
  mov  rbp, rsp
  sub  rsp, 32

  mov qword [acc_ptr], rdi
  mov qword [pin_ptr], rsi
  mov qword [bal_ptr], rdx

  ; Greet the user (Diplomacy)
  call greeting

  ; Get the pin as a 32 bit integer
  call get_pin               ; Call get_pin function
  mov  [pin_val], eax        ; save pin

  ; Calculate the account number
  mov  edi, eax
  call calculate_account
  mov  [acc_num], eax        ; save account number

  ; Calculate the balance
  mov  edi, eax              ; set account number as the first argument to calculate balance
  mov  esi, [pin_val]        ; set pin as the second argument to calculate balance
  call calculate_balance

  ; Convert the balance to ascii and store it in the balance pointer 
  push rax
  push qword [bal_ptr]
  call to_string
  add  rsp, 16

  ; Convert the pin to ascii and store it in the pin pointer 
  push qword [pin_val]
  push qword [pin_ptr]
  call to_string
  add  rsp, 16

  ; Convert the account number to ascii and store it in the account number pointer 
  push qword [acc_num]
  push qword [acc_ptr]
  call to_string
  add  rsp, 16

  ; Output account message 
  mov  rdi, "Your account number is:", 10
  call print

  ; Output account number 
  mov  rdi, [acc_ptr]
  call print

  ; Output balance message 
  mov  rdi, "Your balance is:", 10
  call print

  ; Output balance 
  mov  rdi, [bal_ptr]
  call print

  ; Output obscured pin message 
  mov  rdi, "Your obscured PIN is:", 10
  call print

  ; Obsfucate the pin 
  push qword [pin_val]
  call obscure_pin

  ; Output obscured pin 
  mov  rdi, [pin_ptr]
  call print

leave
ret

to_string:
  ; rdi - integer value
  ; rsi - buffer to store result
  push rbp
  mov  rbp, rsp
  sub  rsp, 16

  mov rax, rdi
  mov rbx, 10
  mov rcx, rsi

.loop:
  xor rdx,   rdx
  div rbx
  add dl,    '0'
  mov [rcx], dl
  inc rcx
  cmp rax,   0
  jne .loop

  mov byte [rcx], 0

  leave
  ret

print:
  ; rdi - string to print
  push rbp
  mov  rbp, rsp

  mov rax, 1                 ; write system call number
  mov rdi, 1                 ; file descriptor for standard output
  mov rsi, [rbp + 16]        ; string to print
  mov rdx, [rbp + 24]        ; length of string
  syscall

  leave
  ret
; This tells the function that these exist outside of this file
extern  get_pin
extern  greeting
extern  obscure_pin
extern  calculate_balance
extern  calculate_account

; This makes your function available to other files
global  create_account

section .data
  acc_ptr dq 0
  pin_ptr dq 0
  bal_ptr dq 0

  acc_val dq 0
  pin_val dq 0
  bal_val dq 0

  newline db 10 
  bal_msg db "Your balance is:", 0
  pin_msg db "Your obscured PIN is:", 0
  acc_msg db "Your account number is:", 0

section .text
; void create_account(char *account_number, char *obscured_pin, char *balance)
;
; Inputs:
;   rdi - account number
;   rsi - pin
;   rdx - balance

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
  call get_pin        ; Call get_pin function
  mov  [pin_val], eax ; save pin

  ; Calculate the account number
  mov  edi, [pin_val]
  call calculate_account
  mov  [acc_val], eax    ; save account number

  ; Calculate the balance
  mov  edi, [acc_val]         ; set account number as the first argument to calculate balance
  mov  esi, [pin_val]    ; set pin as the second argument to calculate balance
  call calculate_balance
  mov [bal_val], eax

  mov rdi, [bal_val]
  mov rsi, [bal_ptr]
  call int_to_string

  mov rdi, [pin_val]
  mov rsi, [pin_ptr]
  call int_to_string

  mov rdi, [acc_val]
  mov rsi, [acc_ptr]
  call int_to_string

  ; Obscure pin
  mov rdi, [pin_ptr]
  call obscure_pin

  ; Output account message
  push dword 24
  push dword acc_msg
  call print

  ; Output account number
  push dword 7
  push qword [acc_ptr]
  call print

  ; Output balance message 
  push dword 17
  push dword bal_msg
  call print

  ; Output balance
  push dword 7
  push qword [bal_ptr]
  call print

  ; Output obscured pin message
  push dword 22
  push dword pin_msg
  call print

  ; Output obscured pin 
  push dword 6
  push qword [pin_ptr]
  call print

  leave
  ret

print:
  ; rdi - string to print
  push rbp
  mov  rbp, rsp

  mov rax, 1          ; write system call number
  mov rdi, 1          ; file descriptor for standard output
  mov rsi, [rbp + 16] ; string to print
  mov rdx, [rbp + 24] ; length of string
  syscall

  ; Add a newline
  mov rax, 1          ; write system call number
  mov rdi, 1          ; file descriptor for standard output
  mov rsi, newline    ; address of newline string
  mov rdx, 1          ; length of newline string
  syscall

  leave
  ret

int_to_string:
  push rbp
  mov rbp, rsp
  push rbx
  push rcx
  push rdx

  xor rbx, rbx
  xor rcx, rcx
  mov eax, edi

.reverse:
  xor edx, edx
  mov r8, 10
  div r8
  add dl, '0'
  push rdx
  inc rcx
  cmp eax, 0
  jne .reverse

  ; Reverse the string to get the final result
.reverse_loop:
  pop rax
  mov [rsi + rbx], al
  inc rbx
  loop .reverse_loop

  ; Add null terminator to the end of the string
  mov byte [rsi + rbx], 0

  leave
  ret
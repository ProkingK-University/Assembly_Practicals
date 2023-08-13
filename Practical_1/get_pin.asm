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
  obs_ptr dq 0

  acc_val dq 0
  pin_val dq 0
  bal_val dq 0
  obs_val dq 0
  
  bal_msg db "Your balance is:", 10
  pin_msg db "Your obscured PIN is:", 10
  acc_msg db "Your account number is:", 10

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

  ; mov edi, [pin_val]
  ; call obscure_pin
  ; mov [obs_val], eax

  ; Calculate the account number
  mov  edi, [pin_val]
  call calculate_account
  mov  [acc_val], eax    ; save account number

  ; Calculate the balance
  mov  edi, [acc_val]         ; set account number as the first argument to calculate balance
  mov  esi, [pin_val]    ; set pin as the second argument to calculate balance
  call calculate_balance
  mov [bal_val], eax

  ; Convert the balance to ascii and store it in the balance pointer 
  mov edi, [bal_val]
  lea esi, [bal_ptr]
  call to_string

  ; Convert the pin to ascii and store it in the pin pointer
  mov edi, [pin_val]
  lea esi, [pin_ptr]
  call to_string

  ; Convert the account number to ascii and store it in the account number pointer
  mov edi, [acc_val]
  lea esi, [acc_ptr]
  call to_string

  ; Convert the pin to ascii and store it in the pin pointer
  mov edi, [obs_val]
  lea esi, [obs_ptr]
  call to_string

  ; Output account message
  push dword 24
  push dword acc_msg
  call print

  ; Output account number
  push dword 6
  push dword acc_ptr
  call print

  ; Output balance message 
  push dword 17
  push dword bal_msg
  call print

  ; Output balance 
  push dword 6
  push dword bal_ptr
  call print

  ; Output obscured pin message
  push dword 22
  push dword pin_msg
  call print

  ; Output obscured pin 
  push dword 4
  push dword obs_ptr
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

  ; reverse the order of the digits in the buffer
  mov rdi, rsi ; set RDI to the start of the buffer
  mov rsi, rcx ; set RSI to the end of the buffer
  dec rsi      ; move back one byte to skip the null terminator

.reverse_loop:
  cmp rdi, rsi ; check if we have reached the middle of the buffer
  jge .done

  mov al, [rdi] ; swap the bytes at RDI and RSI
  mov ah, [rsi]
  mov [rdi], ah
  mov [rsi], al

  inc rdi      ; move RDI forward one byte
  dec rsi      ; move RSI back one byte

  jmp .reverse_loop

.done:
  mov byte [rcx], 10 ; add newline
  inc rcx
  mov byte [rcx], 0 ; add null terminator

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

  leave
  ret
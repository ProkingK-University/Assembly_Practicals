; This tells the function that these exist outside of this file
extern greeting
extern get_pin
extern obscure_pin
extern calculate_balance
extern calculate_account

; This makes your function available to other files
global create_account

section .data
; ==========================
; Your data goes here
  acc_ptr dq 0
  pin_ptr dq 0
  bal_ptr dq 0
  acc_num_val dd 0
  pin_val dd 0
  buffer resb 11                ; Reserve space for the ASCII representation of values
  acc_message db "Account Number: ", 0
  bal_message db "Balance: ", 0
  pin_message db "Obscured PIN: ", 0
; ==========================

section .text
; void create_account(char *account_number, char *obscured_pin, char *balance)
create_account:
  push rbp
  mov rbp, rsp
  sub rsp, 32

  mov qword [acc_ptr], rdi
  mov qword [pin_ptr], rsi
  mov qword [bal_ptr], rdx

  ; Greet the user (Diplomacy)
  call greeting

  ; Get the pin as a 32 bit integer
  call get_pin
  mov [pin_val], eax

  ; Calculate the account number
  mov edi, eax
  call calculate_account
  mov [acc_num_val], eax

  ; Calculate the balance
  mov edi, eax
  mov esi, [pin_val]
  call calculate_balance

  ; Convert the balance to ASCII and store it in the balance pointer
  mov eax, edi
  mov rsi, buffer
  call int_to_ascii
  mov rsi, [bal_ptr]
  mov rdi, buffer
  call copy_string

  ; Convert the pin to ASCII and store it in the pin pointer
  mov eax, [pin_val]
  mov rsi, buffer
  call int_to_ascii
  mov rsi, [pin_ptr]
  mov rdi, buffer
  call copy_string

  ; Convert the account number to ASCII and store it in the account number pointer
  mov eax, [acc_num_val]
  mov rsi, buffer
  call int_to_ascii
  mov rsi, [acc_ptr]
  mov rdi, buffer
  call copy_string

  ; Output account message
  mov rdi, acc_message
  call print_string

  ; Output account number
  mov rsi, [acc_ptr]
  call print_string

  ; Output balance message
  mov rdi, bal_message
  call print_string

  ; Output balance
  mov rsi, [bal_ptr]
  call print_string

  ; Obscure the pin
  mov rdi, [pin_ptr]
  call obscure_pin

  ; Output pin message
  mov rdi, pin_message
  call print_string

  ; Output obscured pin
  mov rsi, [pin_ptr]
  call print_string

  leave
  ret

; Convert an integer to ASCII and store it in a buffer
; Inputs:
;   rax - integer value
;   rsi - buffer address
int_to_ascii:
  push rbx
  push rcx
  push rdx

  mov rcx, 10     ; Divisor
  xor rdx, rdx    ; Clear any previous remainder
  div rcx         ; Divide rax by 10, result in rax, remainder in rdx

.reverse_loop:
  add dl, '0'     ; Convert remainder to ASCII
  dec rsi         ; Move buffer pointer backwards
  mov [rsi], dl   ; Store ASCII character in buffer
  xor rdx, rdx    ; Clear any previous remainder
  test rax, rax   ; Check if quotient is zero
  jz .end_reverse
  div rcx          ; Divide rax by 10, result in rax, remainder in rdx
  jmp .reverse_loop

.end_reverse:
  pop rdx
  pop rcx
  pop rbx
  ret

; Subroutine to copy a null-terminated string
; Inputs:
;   rdi - source address
;   rsi - destination address
copy_string:
  xor rcx, rcx      ; Clear counter
.copy_loop:
  mov al, byte [rdi + rcx]    ; Load byte from source
  mov byte [rsi + rcx], al    ; Store byte to destination
  inc rcx
  cmp al, 0                   ; Check for null-terminator
  jnz .copy_loop
  ret

; Subroutine to print a null-terminated string
; Input:
;   rdi - string address
print_string:
  mov rax, 1                  ; syscall number for sys_write
  mov rsi, rdi                ; message address
  mov rdx, 0                  ; message length (will be calculated by the syscall)
  xor rax, rax                ; clear rax to avoid accidental overwrite
  syscall
  ret

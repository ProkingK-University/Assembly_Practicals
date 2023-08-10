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
  balance_val dd 0
  account_message db "Your account number is: ", 0
  balance_message db "Your balance is: $", 0
  pin_message db "Your obscured PIN is: ", 0
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
  call get_pin ; Call get_pin function
  mov [pin_val], eax  ; save pin

  ; Calculate the account number
  mov edi, eax
  call calculate_account
  mov [acc_num_val], eax  ; save account number

  ; Calculate the balance
  mov edi, eax  ; set account number as the first argument to calculate balance
  mov esi, [pin_val]  ; set pin as the second argument to calculate balance
  call calculate_balance
  mov [balance_val], rax  ; save balance

  ; Convert the balance to ascii and store it in the balance pointer
  mov rsi, [bal_ptr]
  mov rax, [balance_val]
  call int_to_ascii
  mov [rsi], rax

  ; Convert the pin to ascii and store it in the pin pointer
  mov rsi, [pin_ptr]
  mov eax, [pin_val]
  call int_to_ascii
  mov [rsi], rax

  ; Convert the account number to ascii and store it in the account number pointer
  mov rsi, [acc_ptr]
  mov eax, [acc_num_val]
  call int_to_ascii
  mov [rsi], rax

  ; Output account message
  mov rax, 1                  ; syscall number for sys_write
  mov rdi, 1                  ; file descriptor 1 (stdout)
  mov rsi, account_message    ; message address
  mov rdx, account_msg_len    ; message length
  syscall

  ; Output account number
  mov rsi, [acc_ptr]
  call output_string

  ; Output balance message
  mov rsi, balance_message
  call output_string

  ; Output balance
  mov rsi, [bal_ptr]
  call output_string

  ; Obsfucate the pin
  mov rsi, [pin_ptr]
  call obscure_pin

  ; Output pin message
  mov rsi, pin_message
  call output_string

  ; Output obscured pin
  mov rsi, [pin_ptr]
  call output_string

  leave
  ret

; Converts an integer to ASCII and returns the result in rax
int_to_ascii:
  ; your code for integer to ASCII conversion here
  ret

; Outputs a null-terminated string pointed to by rsi
output_string:
  ; your code for outputting string here
  ret

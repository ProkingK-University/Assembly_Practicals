; This makes your function available to other files
global calculate_account

section .data
  text db 'Your account number is:',10
  textLen equ $ - text

section .text
  global _start

_start:
  calculate_account:
  ; Arguments:
  ; rdi - pin (Input Argument)

  ; Set up the stack frame

  push rbp        ; Save the base pointer
  mov rbp, rsp    ; Set rbp to the current value of rsp

  ; Print the "Your account number is: " message

  mov rax, 1                  ; syscall number for sys_write
  mov rdi, 1                  ; file descriptor 1 (stdout)
  mov rsi, text               ; message address
  mov rdx, textLen                 ; message length
  syscall

  ; Add 10000 to pin
  
  mov rax, rdi    ; Move the pin value to rax register
  add eax, 10000  ; Add 10000 to eax register

  ; The calculated account is in eax register. Need to store it in rax register
  mov rax, rdi    ; Move the calculated account to rax register

  ; Convert the account number to ASCII
  xor rcx, rcx    ; Clear rcx to prepare for conversion

  .convert_loop:
  dec rsi         ; Move backwards in the buffer
  mov rdx, 10     ; Prepare for division by 10
  div rdx         ; Divide rax by 10, quotient in rax, remainder in rdx
  add dl, '0'     ; Convert remainder to ASCII digit
  mov [rsi], dl   ; Store ASCII digit in the buffer
  test rax, rax   ; Check if quotient is zero
  jnz .convert_loop ; If not zero, continue the loop

  ; rsi now points to the beginning of the ASCII string

  ; The ASCII account number is in [rsi], you can use it for further processing

  leave
  ret

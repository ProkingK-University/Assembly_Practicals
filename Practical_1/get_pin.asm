; This makes your function available to other files
global get_pin

section .data
  prompt db "Enter 4-digit PIN: ", 0   

section .bss
  pin resb 5                  ; Reserve space input

section .text
global _start

_start:
get_pin:                      ; uint32_t get_pin()
  push rbp                    ; Save base pointer onto stack
  mov rbp, rsp                ; Set base pointer to current value on the stack

; Print the message that asks for a pin

  mov rax, 1                  ; syscall number for sys_write
  mov rdi, 1                  ; file descriptor 1 (stdout)
  mov rsi, prompt             ; message address
  mov rdx, 20                 ; message length
  syscall

; Read the pin from stdin and store it in a buffer

  mov rax, 0                  ; syscall number for sys_read
  mov rdi, 0                  ; file descriptor 0 (stdin)
  mov rsi, pin                ; buffer address
  mov rdx, 5                  ; buffer size
  syscall

; Convert the pin to an integer

  xor rax, rax                ; Clear rax to prepare for conversion
  mov rdi, pin                ; Load address of pin buffer
  mov rcx, 10                 ; Multiplier for decimal conversion

.loop:
  movzx r8, byte [rdi]        ; Load the next character as ASCII code
  cmp r8, 0                   ; Check if it's null-terminator
  je .end_loop                ; End the loop

  cmp r8, 10                  ; Check if it's a newline character
  je .end_loop                ; End the loop

  sub r8, '0'                 ; Convert ASCII code to digit value
  imul rax, rcx               ; Multiply current result by 10
  add rax, r8                 ; Add the digit value
  inc rdi                     ; Move to the next character
  jmp .loop                   ; Restart the loop

.end_loop:
  leave
  ret
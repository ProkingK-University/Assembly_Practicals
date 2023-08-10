global obscure_pin

section .data
; ==========================
; Your data goes here
  me db ''
; ==========================

; void obscure_pin(char* pin)
; Obscures a 4-digit ASCII PIN in place.
; Assumes pin is in rdi.
section .text
obscure_pin:
  push rbp
  mov rbp, rsp
; Do not modify anything above this line unless you know what you are doing
; ==========================
; Your code goes here
  xor rax, rax                ;Clear rax register
  xor rcx, rcx                ;Clear rcx register
  mov rcx, 0                  ;Set count to 0

  ; obscure digits
    .loop:
  cmp byte[rdi], 0            ; Check if it's null-terminator
  je .end_loop                ; End the loop
  cmp byte[rdi], 10           ; Check if it's a newline character
  je .end_loop                ; End the loop

  sub  byte[rdi], '0'         ; Convert ASCII code to digit value
  xor  byte[rdi], 0xF         ; XOR  with the hexdecimal of decimal number 15
  add  byte[rdi], 48          ; Add the digit value
  inc rdi                     ; Move to the next character
  inc rcx                     ; Increment count
  jmp .loop                   ; Loop
  .end_loop:
    std                       ; Set Direction Flag(DF) = 1. Addresses will be decreased.

  lea rsi, [rdi]              ;Data to move into rdi
  lea rdi, [rdi]              ;Destination string to swap with

  rep stosd                   ;It just works to reverse. Don't know the specifics
; ==========================
; Do not modify anything below this line unless you know what you are doing

  leave
  ret
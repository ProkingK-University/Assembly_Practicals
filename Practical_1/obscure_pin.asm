global obscure_pin

global obscure_pin

section .data
; ==========================
; Your data goes here

section .bss
  pin resb 5
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
  xor rcx, rcx                ;Clear rcx register
  mov rcx, 0                  ;Set count to 0
  mov r13d, pin               ;Store reserved address of bits into register


  ; load PIN digits in
  .meloop:
  movzx r8, byte[rdi+rcx]
  cmp  r8, 0                  ; Check if it's null-terminator
  je .less                    ; End the loop
  cmp   r8, 10                ; Check if it's a newline character
  je .less                    ; End the loop
  mov [pin+rcx],r8            ; Move value into memory address
  inc rcx                     ; Increment Count for next memory address
  jmp .meloop                 ; Repeat loop

  .less:
  xor rcx,rcx                 ; Clear Register for count
  mov rcx, 0                  ; Set Count_1 to 0.


  ; obscure digits
  .loop:
  cmp  byte[pin+rcx], 0       ; Check if it's null-terminator
  je .end_loop                ; End the loop
  cmp   byte[pin+rcx], 10     ; Check if it's a newline character
  je .end_loop                ; End the loop

  sub  byte[pin+rcx], '0'    ; Convert ASCII code to digit value
  xor  byte[pin+rcx], 0xF    ; XOR  with the hexdecimal of decimal number 15
  add  byte[pin+rcx], 48     ; Add the digit value

  inc rcx                    ; Increment count to get next bit address.
  jmp .loop                  ; Repeat loop

  .end_loop:
  dec rcx                    ; Decrement count by 1 to valid,non-null terminator
  xor r10,r10                ; Clearing register for use.
  xor r15b,r15b              ; Clearing register for use.
  mov r10, 0                 ; Set Count_2 in register to 0.

  ; reverse obscured digits
  .oloop:
  cmp  rcx, -1               ; End of loop condition
  je .free                   ; End of loop
  mov r15b, byte[pin+rcx]    ; Move value into temporary register
  mov byte[rdi+r10],r15b     ; Move from temp register to corresponding valid address in register
  dec rcx                    ; Decrease count_1
  inc r10                    ; Increase count_2
  jmp .oloop                 ; Repeat loop

  .free
; ==========================
; Do not modify anything below this line unless you know what you are doing
  leave
  ret
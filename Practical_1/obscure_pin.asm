section .data
    mask db 0xF         ; Mask value for XOR operation
    zero db 48          ; ASCII value of digit '0'

section .text
global obscure_pin
obscure_pin:
    push rbp
    mov rbp, rsp

    ; Load PIN digits
    mov rsi, rdi        ; Copy the pointer to rsi for processing
    mov r8b, byte [mask] ; Load the mask value into r8b for XOR operation
    
    xor rcx, rcx        ; Clear rcx (loop counter)
    
    ; Store the obscured PIN in reverse order
.obfuscate_loop:
    mov al, byte [rsi + rcx] ; Load the current character into AL
    cmp al, 0           ; Check for null terminator
    je .reverse_loop    ; If null terminator is reached, proceed to reversal
    
    sub al, byte [zero] ; Convert ASCII to numerical value (di - 48)
    xor al, r8b         ; Perform XOR operation with the mask (0xF)
    add al, byte [zero] ; Convert back to ASCII representation (d'i + 48)
    mov byte [rsi + rcx], al ; Store the result back in the PIN string
    
    inc rcx             ; Increment the loop counter
    jmp .obfuscate_loop

.reverse_loop:
    dec rcx             ; Decrement the loop counter
    js .done             ; If all characters have been processed, exit
    
    mov al, byte [rsi + rcx] ; Load the current character into AL
    mov ah, byte [rsi + 6]   ; Load the corresponding character from the opposite end
    mov byte [rsi + rcx], ah ; Swap the characters
    mov byte [rsi + 3], al   ; Swap the characters
    
    jmp .reverse_loop

.done:
    pop rbp
    ret

# Documentation for Practical_2

## Explanation of Vigenère cipher:

### How to encrypt Vigenère:
1. Choose a keyword, for example, "KEY."
2. Repeat the keyword to match the length of the plaintext. If the plaintext is "HELLO," the repeated keyword becomes "KEYKE."
3. Assign a number to each letter of the keyword (A=0, B=1, ..., Z=25).
4. For each letter in the plaintext and its corresponding letter in the keyword, find the sum of their assigned numbers.
5. Take the result modulo 26 to get a new number.
6. Convert the new number back to a letter (A=0, B=1, ..., Z=25) to get the ciphertext letter.

### How to decrypt Vigenère:
1. Repeat the keyword to match the length of the ciphertext.
2. Convert the letter of the keyword and the corresponding letter of the ciphertext to their assigned numbers.
3. Subtract the keyword letter's number from the ciphertext letter's number.
4. If the result is negative, add 26 to it.
5. Convert the result to a letter to obtain the plaintext letter. <br>

**The security of the Vigenère cipher increases with the length of the keyword. A longer keyword makes frequency analysis and other traditional cryptanalysis methods less effective, as the shifting pattern becomes more complex.** <br>

## Explanation of Challenge 1:

### How should we push arrays to functions:
Pass the address to first element of matrix, along with information about row/column count.
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

char **populateMatrix();
void removeSpaces(char *str);
char *encryptString(char **vigenereSquare, char *keyword, char *plaintext);
char encryptChar(char **vigenereSquare, char keywordChar, char plaintextChar);

int main()
{
    char **vigenereSquare = populateMatrix();

    char keyword[] = "LEMON";
    char plaintext[] = "ATTACK AT DAWN";

    removeSpaces(plaintext);

    char *encryptedText = encryptString(vigenereSquare, keyword, plaintext);

    printf("Plaintext: %s\n", plaintext);
    printf("Keyword: %s\n", keyword);
    printf("Encrypted Text: %s\n", encryptedText);

    // Free memory
    for (int i = 0; i < 26; i++)
    {
        free(vigenereSquare[i]);
    }
    free(vigenereSquare);
    free(encryptedText);

    return 0;
}

// Function to remove spaces from a string
void removeSpaces(char *str)
{
    int length = strlen(str);
    int j = 0;
    for (int i = 0; i < length; i++)
    {
        if (!isspace((unsigned char)str[i]))
        {
            str[j++] = str[i];
        }
    }
    str[j] = '\0';
}

// Function to create and populate the Vigenère Square
char **populateMatrix()
{
    char **vigenereSquare = (char **)malloc(26 * sizeof(char *));
    for (int i = 0; i < 26; i++)
    {
        vigenereSquare[i] = (char *)malloc(26 * sizeof(char));
        for (int j = 0; j < 26; j++)
        {
            vigenereSquare[i][j] = 'A' + (i + j) % 26;
        }
    }
    return vigenereSquare;
}

// Function to find the intersection from the Vigenère Square
char encryptChar(char **vigenereSquare, char keywordChar, char plaintextChar)
{
    int row = keywordChar - 'A';
    int col = plaintextChar - 'A';
    return vigenereSquare[row][col];
}

// Function to encrypt a string using the Vigenère cipher
char *encryptString(char **vigenereSquare, char *keyword, char *plaintext)
{
    int keywordLength = strlen(keyword);
    int plaintextLength = strlen(plaintext);

    char *encryptedText = (char *)malloc(plaintextLength + 1);

    for (int i = 0; i < plaintextLength; i++)
    {
        char keywordChar = keyword[i % keywordLength];
        char plaintextChar = plaintext[i];
        encryptedText[i] = encryptChar(vigenereSquare, keywordChar, plaintextChar);
    }
    encryptedText[plaintextLength] = '\0';

    return encryptedText;
}

// Compile:
// gcc main.c -o main

// Run
// ./main

// You should be ashamed if you do not know this :D
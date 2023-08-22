#include <stdio.h>
#include <stdlib.h>

extern char** populateMatrix();
extern char encryptChar(char**, char, char);
//extern char* encryptString(char**, char*, char*);

int main()
{
    char** matrix = populateMatrix();

    /*for (int i = 0; i < 26; ++i) {
        for (int j = 0; j < 26; ++j) {
            printf("'%c' ", matrix[i][j]);
        }
        printf("\n");
    }*/

    char input = 'B';
    char key = 'Z';
    printf("%c - %c -> %c\n", input, key, encryptChar(matrix, input, key));
    input = 'Z';
    key = 'Z';
    printf("%c - %c -> %c\n", input, key, encryptChar(matrix, input, key));
    input = 'A';
    key = 'L';
    printf("%c - %c -> %c\n", input, key, encryptChar(matrix, input, key));
    input = 'O';
    key = 'P';
    printf("%c - %c -> %c\n", input, key, encryptChar(matrix, input, key));

    for (int i = 0; i < 26; ++i) {
        free(matrix[i]);
    }
    free(matrix);
    
    /*char* output = 0;

    char pt[50];
    char kw[50];

    sprintf(pt, "ATTACK AT DAWN");
    sprintf(kw, "LEMON");
    printf("%s", pt);
    printf(" -- %s --> ", kw);
    output = encryptString(0, pt, kw);
    printf("%s\n", output);

    sprintf(pt, "OHWHYOHWHYDOWEWAIT");
    sprintf(kw, "POTATO");
    printf("%s", pt);
    printf(" -- %s --> ", kw);
    output = encryptString(0, pt, kw);
    printf("%s\n", output);

    sprintf(pt, "SOMEEXSTRASPACESINBETWEENLOL");
    sprintf(kw, "SPACES");
    printf("%s", pt);
    printf(" -- %s --> ", kw);
    output = encryptString(0, pt, kw);
    printf("%s\n", output);

    sprintf(pt, "SOMEEXTRASPACESATTHEBACK");
    sprintf(kw, "EXTRA");
    printf("%s", pt);
    printf(" -- %s --> ", kw);
    output = encryptString(0, pt, kw);
    printf("%s\n", output);

    sprintf(pt, "EXTRASPACESATTHEFRONT");
    sprintf(kw, "COSTWOEIGHTFOUR");
    printf("%s", pt);
    printf(" -- %s --> ", kw);
    output = encryptString(0, pt, kw);
    printf("%s\n", output);

    sprintf(pt, "EXTRASPACESEVERYWHERE");
    sprintf(kw, "ONETWOTHREE");
    printf("%s", pt);
    printf(" -- %s --> ", kw);
    output = encryptString(0, pt, kw);
    printf("%s\n", output);

    sprintf(pt, "ABCDEFGHIJKLMNOPQRSTUVWXYZ");
    sprintf(kw, "ABCDEFGHIJKLMNOPQRSTUVWXYZ");
    printf("%s", pt);
    printf(" -- %s --> ", kw);
    output = encryptString(0, pt, kw);
    printf("%s\n", output);*/

    return 0;
}
/*
ATTACK AT DAWN -- LEMON --> LXFOPVEFRNHR
OHWHYOHWHYDOWEWAIT -- POTATO --> DVPHRCWKAYWCLSPABH
SOMEEXSTRASPACESINBETWEENLOL -- SPACES --> KDMGIPKIRCWHSREUMFTTTYIWFAON
SOMEEXTRASPACESATTHEBACK -- EXTRA --> WLFVEBQKRSTXVVSEQMYEFXVB
EXTRASPACESATTHEFRONT -- COSTWOEIGHTFOUR --> GLLKWGTIILLFHNYGTJHJH
EXTRASPACESEVERYWHERE -- ONETWOTHREE --> SKXKWGIHTIWSIIKUKALII
ABCDEFGHIJKLMNOPQRSTUVWXYZ -- ABCDEFGHIJKLMNOPQRSTUVWXYZ --> ACEGIKMOQSUWYACEGIKMOQSUWY
*/
#ifndef LEXER_H
#define LEXER_H
struct idCounter {
    char name[500];
    int count;
} ids[1000];

extern int idsCount;

int searchName(char *name);
int addName(char *name);
#endif
#ifndef SCOPE_H
#define SCOPE_H
#include "./object.h"
#define LEVELS 100
#define IDS_PER_LEVEL 100

struct idCounter {
    char name[500];
    int count;
} ids[LEVELS][IDS_PER_LEVEL];

extern int currentLevel;

extern int idsCount[LEVELS];

int searchName(char *name);
int addName(char *name);

int NewBlock(void);
int EndBlock(void);

#endif

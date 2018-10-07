#ifndef SCOPE_H
#define SCOPE_H
#include "./object.h"

int NewBlock(void);
int EndBlock(void);
pobject Define(int aName);
pobject Search (int aName);
pobject Find (int aName);

#endif
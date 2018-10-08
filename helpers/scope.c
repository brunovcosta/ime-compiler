#include <stdlib.h>
#include <stdio.h>
#include "./lexer.h"

#include "./scope.h"

//TODO what is the max nest level
#define MAX_NEST_LEVEL 10

pobject SymbolTable[MAX_NEST_LEVEL];
pobject SymbolTableLast[MAX_NEST_LEVEL];
int nCurrentLevel = -1;

int NewBlock(void) {
    SymbolTable[++nCurrentLevel] = NULL;
    SymbolTableLast[nCurrentLevel] = NULL;
    return nCurrentLevel;
}

int EndBlock(void) {
    return --nCurrentLevel;
}

//pobject Define(int aName) {
//    pobject obj = (pobject)malloc(sizeof(object));
//    obj->nName = aName;
//    obj->pNext = NULL;
//    if (SymbolTable[nCurrentLevel] == NULL)
//    {
//        SymbolTable[nCurrentLevel] = obj;
//        SymbolTableLast[nCurrentLevel] = obj;
//    }
//    else
//    {
//        SymbolTableLast[nCurrentLevel]->pNext = obj;
//        SymbolTableLast[nCurrentLevel] = obj;
//    }
//    return obj;
//}
//
//pobject Search(int aName)
//{
//    pobject obj = SymbolTable[nCurrentLevel];
//    while (obj != NULL)
//    {
//        if (obj->nName == aName)
//            break;
//        else
//            obj = obj->pNext;
//    }
//    return obj;
//}
//
//pobject Find(int aName)
//{
//    int i;
//    pobject obj = NULL;
//    for (i = nCurrentLevel; i >= 0; --i)
//    {
//        obj = SymbolTable[i];
//        while (obj != NULL)
//        {
//            if (obj->nName == aName)
//                break;
//            else
//                obj = obj->pNext;
//        }
//        if (obj != NULL)
//            break;
//    }
//    return obj;
//}
//
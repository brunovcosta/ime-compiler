#include <stdlib.h>
#include<string.h>
#include <stdio.h>

#include "./scope.h"


//TODO what is the max nest level
#define MAX_NEST_LEVEL 10


int idsCount[LEVELS]={};
int secondaryToken=0;
int currentLevel = 0;

int searchName(char *name){
	int pos;
	int level;
	for(level=0;level < currentLevel;level++){
		for(pos=0;pos<idsCount[level];pos++){
			if(strcmp(name,ids[level][pos].name) == 0){
				return pos;
			}
		}
	}
	return -1;
}

int addName(char *name){
	int pos;
	for(pos=0;pos<idsCount[currentLevel];pos++){
		if(strcmp(name,ids[currentLevel][pos].name) == 0){ //achou
			ids[currentLevel][pos].count++;
			return pos;
		}
	}
	idsCount[currentLevel]++;
	strcpy(ids[currentLevel][pos].name,name);
	ids[currentLevel][pos].count=1;
	return pos;
}

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


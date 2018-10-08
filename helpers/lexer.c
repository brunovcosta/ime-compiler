#include <string.h>
#include "./lexer.h"

int idsCount=0;
int secondaryToken=0;

int searchName(char *name){
    int pos;
    for(pos=0;pos<idsCount;pos++){
        puts("---------------------------");
        printf("name: %s\n",name);
        printf("name: %s\n",ids[pos].name);
        puts("---------------------------");
        //if(strcmp(name,ids[pos].name) != 0){
        //    return pos;
        //}
    }
    puts("pasdasdasd \n");
    return -1;
}

int addName(char *name){
    int pos;
    for(pos=0;pos<idsCount;pos++){
        printf("addName: comparing %s with %s\n",name,ids[pos].name);
        if(strcmp(name,ids[pos].name) == 0){ //achou
            ids[pos].count++;
            printf("Found name! addName returning %d\n", pos);
            return pos;
        }
    }
    idsCount++;
    strcpy(ids[pos].name,name);
    ids[pos].count=1;
    printf("Did not find name! addName returning %d\n",pos);
    return pos;
}
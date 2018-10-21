#include "./code.h"
#include <stdio.h>
#include <stdarg.h>

void generateCode(char *code,int num, ...){
	va_list params;
	va_start(params,num);
	printf("code generated: %s",code);

	int i=0;
	for(i=0;i<num;i++)
		printf(" %d",va_arg(params,int));

	va_end(params);

	printf("\n");
}

int getConstantNumber(){
	return constantNumber++;
}

int getFunctionNumber(){
	return functionNumber++;
}

int getCheckpoint(){
	return checkpoint++;
}

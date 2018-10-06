%{
	#include <stdio.h>
    #include "simple_script_language.tab.h"
	void count();
%}

%%

"else"                {return ELSE;}
"break"               {return BREAK;}
"while"               {return WHILE;}
"var"                 {return VAR;}
"="                   {return ASSIGN;}
"continue"            {return CONTINUE;}
"function"            {return FUNCTION;}
"string"              {return STRING;}
"if"                  {return IF;}
"boolean"             {return BOOLEAN;}
"char"                {return CHAR;}
"integer"             {return INTEGER;}
"return"              {return RETURN;}
"do"                  {return DO;}
">="                  {return GREATER_OR_EQUAL;}
"<="                  {return LESS_OR_EQUAL;}
">"                   {return GREATER_THAN;}
"<"                   {return LESS_THAN;}
"("                   {return LEFT_PARENTHESIS;}
")"                   {return RIGHT_PARENTHESIS;}
"["                   {return LEFT_SQUARE;}
"]"                   {return RIGHT_SQUARE;}
"{"                   {return LEFT_BRACES;}
"}"                   {return RIGHT_BRACES;}
":"                   {return COLON;}
";"                   {return SEMI_COLON;}
"."                   {return DOT;}
","                   {return COMMA;}
"!"                   {return NOT;}
[0-9]+                {return num;}
\"[a-zA-Z]+\"         {return str;}
'.'                   {return chr;}
[a-zA-Z]+             {return id;}
[ \t\v\n\f]           { /* ignore blank characters */ }
.                     { yyerror("char not recognized, bitch!"); }

%%

int column = 0;

void count() {
	int i;

	for (i = 0; yytext[i] != '\0'; i++)
		if (yytext[i] == '\n')
			column = 0;
		else if (yytext[i] == '\t')
			column += 8 - (column % 8);
		else
			column++;

	ECHO;
}

int check_type() {
/*
* pseudo code --- this is what it should check
*
*	if (yytext == type_name)
*		return(TYPE_NAME);
*
*	return(IDENTIFIER);
*/

/*
*	it actually will only return IDENTIFIER
*/

	return(id);
}

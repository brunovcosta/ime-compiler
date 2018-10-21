%{
	#include <stdio.h>
	#include "./parser.tab.h"
	#include "./helpers/shared.h"

	int line = 0;

%}
%%

"else"                {printf(">>");ECHO;printf("\n");return ELSE;}
"break"               {printf(">>");ECHO;printf("\n");return BREAK;}
"while"               {printf(">>");ECHO;printf("\n");return WHILE;}
"var"                 {printf(">>");ECHO;printf("\n");return VAR;}
"="                   {printf(">>");ECHO;printf("\n");return ASSIGN;}
"continue"            {printf(">>");ECHO;printf("\n");return CONTINUE;}
"function"            {printf(">>");ECHO;printf("\n");return FUNCTION;}
"string"              {printf(">>");ECHO;printf("\n");return STRING;}
"if"                  {printf(">>");ECHO;printf("\n");return IF;}
"boolean"             {printf(">>");ECHO;printf("\n");return BOOLEAN;}
"char"                {printf(">>");ECHO;printf("\n");return CHAR;}
"type"                {printf(">>");ECHO;printf("\n");return TYPE;}
"integer"             {printf(">>");ECHO;printf("\n");return INTEGER;}
"return"              {printf(">>");ECHO;printf("\n");return RETURN;}
"do"                  {printf(">>");ECHO;printf("\n");return DO;}
"of"                  {printf(">>");ECHO;printf("\n");return OF;}
"struct"              {printf(">>");ECHO;printf("\n");return STRUCT;}
">="                  {printf(">>");ECHO;printf("\n");return GREATER_OR_EQUAL;}
"=="                  {printf(">>");ECHO;printf("\n");return EQUALS;}
"<="                  {printf(">>");ECHO;printf("\n");return LESS_OR_EQUAL;}
">"                   {printf(">>");ECHO;printf("\n");return GREATER_THAN;}
"<"                   {printf(">>");ECHO;printf("\n");return LESS_THAN;}
"("                   {printf(">>");ECHO;printf("\n");return LEFT_PARENTHESIS;}
")"                   {printf(">>");ECHO;printf("\n");return RIGHT_PARENTHESIS;}
"+"                   {printf(">>");ECHO;printf("\n");return PLUS;}
"-"                   {printf(">>");ECHO;printf("\n");return MINUS;}
"++"                  {printf(">>");ECHO;printf("\n");return PLUS_PLUS;}
"--"                  {printf(">>");ECHO;printf("\n");return MINUS_MINUS;}
"["                   {printf(">>");ECHO;printf("\n");return LEFT_SQUARE;}
"]"                   {printf(">>");ECHO;printf("\n");return RIGHT_SQUARE;}
"{"                   {printf(">>");ECHO;printf("\n");return LEFT_BRACES;}
"}"                   {printf(">>");ECHO;printf("\n");return RIGHT_BRACES;}
":"                   {printf(">>");ECHO;printf("\n");return COLON;}
";"                   {printf(">>");ECHO;printf("\n");return SEMI_COLON;}
"."                   {printf(">>");ECHO;printf("\n");return DOT;}
","                   {printf(">>");ECHO;printf("\n");return COMMA;}
"!"                   {printf(">>");ECHO;printf("\n");return NOT;}
"true"                {printf(">>");ECHO;printf("\n");return const_true;}
"false"               {printf(">>");ECHO;printf("\n");return const_false;}
\[(.*,)*\]            {printf(">>");ECHO;printf("\n");return const_array;}
[0-9]+                {printf(">>");ECHO;printf("\n");return const_number;}
\"[a-zA-Z]+\"         {printf(">>");ECHO;printf("\n");return const_string;}
'.'                   {printf(">>");ECHO;printf("\n");return const_char;}
[a-zA-Z]+             {printf(">>");ECHO;printf("\n");secondaryToken = addName(yytext);return id;}
[ \t\v\f]             {printf(">>");ECHO;printf("\n"); /* ignore blank characters */ }
\n                    {printf(">>");ECHO;printf("\n");++line;}
.                     {printf(">>");ECHO;printf("\n"); puts("lexer error: invalid character"); exit(1); }


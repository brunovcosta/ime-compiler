%{
	#include <stdio.h>
	#include "./parser.tab.h"
	#include "./helpers/shared.h"

	int line = 0;

%}
%%

"else"                {ECHO;printf("\t\t->\n");return ELSE;}
"break"               {ECHO;printf("\t\t->\n");return BREAK;}
"while"               {ECHO;printf("\t\t->\n");return WHILE;}
"var"                 {ECHO;printf("\t\t->\n");return VAR;}
"="                   {ECHO;printf("\t\t->\n");return ASSIGN;}
"continue"            {ECHO;printf("\t\t->\n");return CONTINUE;}
"function"            {ECHO;printf("\t\t->\n");return FUNCTION;}
"string"              {ECHO;printf("\t\t->\n");return STRING;}
"if"                  {ECHO;printf("\t\t->\n");return IF;}
"boolean"             {ECHO;printf("\t\t->\n");return BOOLEAN;}
"char"                {ECHO;printf("\t\t->\n");return CHAR;}
"type"                {ECHO;printf("\t\t->\n");return TYPE;}
"integer"             {ECHO;printf("\t\t->\n");return INTEGER;}
"return"              {ECHO;printf("\t\t->\n");return RETURN;}
"do"                  {ECHO;printf("\t\t->\n");return DO;}
"of"                  {ECHO;printf("\t\t->\n");return OF;}
"struct"              {ECHO;printf("\t\t->\n");return STRUCT;}
">="                  {ECHO;printf("\t\t->\n");return GREATER_OR_EQUAL;}
"<="                  {ECHO;printf("\t\t->\n");return LESS_OR_EQUAL;}
">"                   {ECHO;printf("\t\t->\n");return GREATER_THAN;}
"<"                   {ECHO;printf("\t\t->\n");return LESS_THAN;}
"("                   {ECHO;printf("\t\t->\n");return LEFT_PARENTHESIS;}
")"                   {ECHO;printf("\t\t->\n");return RIGHT_PARENTHESIS;}
"+"                   {ECHO;printf("\t\t->\n");return PLUS;}
"-"                   {ECHO;printf("\t\t->\n");return MINUS;}
"++"                  {ECHO;printf("\t\t->\n");return PLUS_PLUS;}
"--"                  {ECHO;printf("\t\t->\n");return MINUS_MINUS;}
"["                   {ECHO;printf("\t\t->\n");return LEFT_SQUARE;}
"]"                   {ECHO;printf("\t\t->\n");return RIGHT_SQUARE;}
"{"                   {ECHO;printf("\t\t->\n");return LEFT_BRACES;}
"}"                   {ECHO;printf("\t\t->\n");return RIGHT_BRACES;}
":"                   {ECHO;printf("\t\t->\n");return COLON;}
";"                   {ECHO;printf("\t\t->\n");return SEMI_COLON;}
"."                   {ECHO;printf("\t\t->\n");return DOT;}
","                   {ECHO;printf("\t\t->\n");return COMMA;}
"!"                   {ECHO;printf("\t\t->\n");return NOT;}
"true"                {ECHO;printf("\t\t->\n");return const_true;}
"false"               {ECHO;printf("\t\t->\n");return const_false;}
\[(.*,)*\]            {ECHO;printf("\t\t->\n");return const_false;}
[0-9]+                {ECHO;printf("\t\t->\n");return const_number;}
\"[a-zA-Z]+\"         {ECHO;printf("\t\t->\n");return const_string;}
'.'                   {ECHO;printf("\t\t->\n");return const_char;}
[a-zA-Z]+             {ECHO;printf("\t\t-> (%s)\n",yytext);secondaryToken = addName(yytext);return id;}
[ \t\v\f]             { /* ignore blank characters */ }
\n                    {++line;}
.                     { puts("deu ruim!"); }


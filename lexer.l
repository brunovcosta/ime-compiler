%{
	#include <stdio.h>
	#include "./parser.tab.h"
	#include "./helpers/shared.h"

	int line = 0;

%}
%%

"else"                {return ELSE;}
"break"               {return BREAK;}
"while"               {return WHILE;}
"var"                 {return VAR;}
"continue"            {return CONTINUE;}
"function"            {return FUNCTION;}
"string"              {return STRING;}
"if"                  {return IF;}
"boolean"             {return BOOLEAN;}
"char"                {return CHAR;}
"type"                {return TYPE;}
"integer"             {return INTEGER;}
"return"              {return RETURN;}
"do"                  {return DO;}
"of"                  {return OF;}
"struct"              {return STRUCT;}
">="                  {return GREATER_OR_EQUAL;}
"=="                  {return EQUALS;}
"="                   {return ASSIGN;}
"<="                  {return LESS_OR_EQUAL;}
">"                   {return GREATER_THAN;}
"<"                   {return LESS_THAN;}
"("                   {return LEFT_PARENTHESIS;}
")"                   {return RIGHT_PARENTHESIS;}
"*"                   {return TIMES;}
"/"                   {return DIVIDE;}
"+"                   {return PLUS;}
"-"                   {return MINUS;}
"++"                  {return PLUS_PLUS;}
"--"                  {return MINUS_MINUS;}
"["                   {return LEFT_SQUARE;}
"]"                   {return RIGHT_SQUARE;}
"{"                   {return LEFT_BRACES;}
"}"                   {return RIGHT_BRACES;}
":"                   {return COLON;}
";"                   {return SEMI_COLON;}
"."                   {return DOT;}
","                   {return COMMA;}
"!"                   {return NOT;}
"true"                {return const_true;}
"false"               {return const_false;}
\[(.*,)*\]            {return const_array;}
[0-9]+                {return const_number;}
\"[a-zA-Z]+\"         {return const_string;}
'.'                   {return const_char;}
[a-zA-Z]+             {secondaryToken = addName(yytext);return id;}
[ \t\v\f]             { /* ignore blank characters */ }
\n                    {++line;}
.                     {puts("lexer error: invalid character"); exit(1); }


%{
	#include <stdio.h>
	#include "./parser.tab.h"
	#include "./helpers/shared.h"

	int line = 0;

%}
%%

"else"                {ECHO;return ELSE;}
"break"               {ECHO;return BREAK;}
"while"               {ECHO;return WHILE;}
"var"                 {ECHO;return VAR;}
"continue"            {ECHO;return CONTINUE;}
"function"            {ECHO;return FUNCTION;}
"string"              {ECHO;return STRING;}
"if"                  {ECHO;return IF;}
"boolean"             {ECHO;return BOOLEAN;}
"char"                {ECHO;return CHAR;}
"type"                {ECHO;return TYPE;}
"integer"             {ECHO;return INTEGER;}
"return"              {ECHO;return RETURN;}
"do"                  {ECHO;return DO;}
"of"                  {ECHO;return OF;}
"struct"              {ECHO;return STRUCT;}
">="                  {ECHO;return GREATER_OR_EQUAL;}
"=="                  {ECHO;return EQUALS;}
"!="                  {ECHO;return NOT_EQUAL;}
"+="                  {ECHO;return PLUS_EQUAL;}
"-="                  {ECHO;return MINUS_EQUAL;}
"*="                  {ECHO;return TIMES_EQUAL;}
"/="                  {ECHO;return DIVIDE_EQUAL;}
"="                   {ECHO;return ASSIGN;}
"<="                  {ECHO;return LESS_OR_EQUAL;}
">"                   {ECHO;return GREATER_THAN;}
"<"                   {ECHO;return LESS_THAN;}
"("                   {ECHO;return LEFT_PARENTHESIS;}
")"                   {ECHO;return RIGHT_PARENTHESIS;}
"*"                   {ECHO;return TIMES;}
"/"                   {ECHO;return DIVIDE;}
"+"                   {ECHO;return PLUS;}
"-"                   {ECHO;return MINUS;}
"++"                  {ECHO;return PLUS_PLUS;}
"--"                  {ECHO;return MINUS_MINUS;}
"["                   {ECHO;return LEFT_SQUARE;}
"]"                   {ECHO;return RIGHT_SQUARE;}
"{"                   {ECHO;return LEFT_BRACES;}
"}"                   {ECHO;return RIGHT_BRACES;}
":"                   {ECHO;return COLON;}
";"                   {ECHO;return SEMI_COLON;}
"."                   {ECHO;return DOT;}
","                   {ECHO;return COMMA;}
"!"                   {ECHO;return NOT;}
"true"                {ECHO;return const_true;}
"false"               {ECHO;return const_false;}
\[(.*,)*\]            {ECHO;return const_array;}
[0-9]+                {ECHO;return const_number;}
\"[a-zA-Z]+\"         {ECHO;return const_string;}
'.'                   {ECHO;return const_char;}
[a-zA-Z]+             {ECHO;secondaryToken = addName(yytext);return id;}
[ \t\v\f]             {ECHO; /* ignore blank characters */ }
\n                    {ECHO;++line;}
.                     {ECHO;puts("lexer error: invalid character"); exit(1); }


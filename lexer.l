%{
	#include <stdio.h>
	#include "./parser.tab.h"

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
"type"                {return TYPE;}
"integer"             {return INTEGER;}
"return"              {return RETURN;}
"do"                  {return DO;}
"of"                  {return OF;}
"struct"              {return STRUCT;}
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
"true"                {return const_true;}
"false"               {return const_false;}
\[(.*,)*\]            {return const_false;}
[0-9]+                {return const_number;}
\"[a-zA-Z]+\"         {return const_string;}
'.'                   {return const_char;}
[a-zA-Z]+             {return id;}
[ \t\v\n\f]           { /* ignore blank characters */ }
.                     { puts("deu ruim!"); }


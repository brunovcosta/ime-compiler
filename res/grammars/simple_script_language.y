%{
#include <stdio.h>
#include <string.h>
#include "./y.tab.h"
 
void yyerror(const char *error) {
	fprintf(stderr,"error: %s\n",error);
}
 
int yywrap() {
	return 1;
} 
  
int main(int argc, char **argv){
	yyparse();
	return 0;
} 

%}
%token COLON SEMI_COLON COMMA EQUALS LEFT_SQUARE RIGHT_SQUARE LEFT_BRACES RIGHT_BRACES LEFT_PARENTHESIS RIGHT_PARENTHESIS AND OR LESS_THAN GREATER_THAN LESS_OR_EQUAL GREATER_OR_EQUAL NOT_EQUAL EQUAL_EQUAL PLUS PLUS_PLUS MINUS MINUS_MINUS TIMES DIVIDE DOT NOT
%token RETURN ELSE DT BREAK WHILE VAR ASSIGN CONTINUE FUNCTION STRING IF BOOLEAN CHAR INTEGER DO
%token chr num str id true false
%start P
%%
/* Um Programa (P) é formado por uma Lista de Declarações Externas (LDE) */

P : LDE ;

LDE : LDE DE 
    | DE ;

/* Uma Declaração Externa (DE) é uma Declaração de Função (DF) ou uma Declaração de Tipo (DT) ou uma Declaração de Variáveis (DV): */

DE : DF 
   | DT ;

/* Um Tipo (T) pode ser a palavra ‘integer’ ou a palavra ‘char’ ou a palavra ‘boolean’ ou a palavra ‘string’ ou um ID representando um tipo previamente declarado: */

T : INTEGER 
  | CHAR 
  | BOOLEAN 
  | STRING 
  | ID ;

/* Uma Declaração de Tipo (DT) pode ser uma declaração de um tipo vetor ou um tipo estrutura ou um tipo sinônimo.

DT : type ID ASSIGN array LEFT_SQUARE NUM RIGHT_SQUARE OF T 
   | type ID ASSIGN STRUCT LEFT_BRACES DC RIGHT_BRACES 
   | type ID ASSIGN T ;

DC : DC SEMI_COLON LI COLON T 
   | LI COLON T ;

/* Uma Declaração de Função é formada pela palavra ‘function’ seguida pelo nome da função (ID) seguida da Lista de Parâmetros (LP) entre parênteses seguida por ‘:’ e pelo Tipo (T) de retorno seguido pelo Bloco (B): */

DF : FUNCTION ID LEFT_PARENTHESIS LP RIGHT_PARENTHESIS COLON T B ;

LP : LP COMMA ID COLON T 
   | ID COLON T
   |  ;

/* Um Bloco (B) é delimitado por chave e contém uma Lista de Declaração de Variáveis (LDV) seguida por uma Lista de Statements (LS) ou Comandos: */

B : LEFT_BRACES LDV LS RIGHT_BRACES ;

LDV : LDV DV 
    | DV ;

LS : LS S 
   | S ;

/* Uma Declaração de Variáveis (DV) é formada pela palavra ‘var’ seguida por uma Lista de Identificadores (LI), separados por ‘,’, seguida de ‘:’ e do Tipo (T) das variáveis declaradas com um ‘;’ ao final. */

DV : VAR LI COLON T SEMI_COLON ;

LI : LI COMMA ID 
   | ID ;

/* Um Statement (S) pode ser um comando de seleção, repetição, um bloco, uma atricbuição ou um comando de controle de fluxo de repetição (‘break’ ou ‘continue’): */

S : IF LEFT_PARENTHESIS E RIGHT_PARENTHESIS S 
  /*| IF LEFT_PARENTHESIS E RIGHT_PARENTHESIS S ELSE S */
  | WHILE LEFT_PARENTHESIS E RIGHT_PARENTHESIS S 
  | DO S WHILE LEFT_PARENTHESIS E RIGHT_PARENTHESIS SEMI_COLON 
  | B 
  | LV ASSIGN E SEMI_COLON 
  | BREAK SEMI_COLON 
  | CONTINUE SEMI_COLON
  | RETURN E SEMI_COLON ;
  
/* Uma Expressão (E) pode ser composta por operadores lógicos, relacionais ou aritméticos, além de permitir o acesso aos componentes dos tipos agregados e da atribuição de valores: */

E : E AND L 
  | E OR L 
  | L ;

L : L LESS_THAN R 
  | L GREATER_THAN R 
  | L LESS_OR_EQUAL R 
  | L GREATER_OR_EQUAL R 
  | L EQUALS R 
  | L NOT_EQUAL R 
  | R ;

R : R PLUS Y 
  | R MINUS Y 
  | Y ;

Y : Y TIMES F 
  | Y DIVIDE F 
  | F ;

F : LV 
  | PLUS_PLUS LV 
  | MINUS_MINUS LV 
  | LV PLUS_PLUS 
  | LV MINUS_MINUS 
  | LEFT_PARENTHESIS E RIGHT_PARENTHESIS 
  | ID LEFT_PARENTHESIS LE RIGHT_PARENTHESIS 
  | MINUS F 
  | NOT 
  | TRUE 
  | FALSE
  | CHR
  | STR
  | NUM ;

LE : LE COMMA E
   | E ;

LV : LV DOT ID
   | LV LEFT_SQUARE E RIGHT_SQUARE
   | ID ;

ID : id;

TRUE: true;
FALSE: false;
CHR: chr;
STR: str;
NUM: num;

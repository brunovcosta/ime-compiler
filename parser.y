%{
#include <stdio.h>
#include <string.h>
#include "./parser.tab.h"
#include "./headers.h"
 
void yyerror(const char *error) {
	fprintf(stderr,"error: %s\n",error);
}
 
int yywrap() {
	puts("deu bom!");
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

%union{
	int nont;
	union {
		struct {
			pobject obj;
			int name;
		} ID;
		struct {
			pobject type;
		} T,E,L,R,TM,F,LV;
		struct{
			pobject list;
		} LI,DC;
		struct{
			pobject list;
			int nSize;
		} LP;
		struct{
			bool val;
			pobject type;
		} BOOL;
		struct {
			pobject type;
			int pos;
			union {
				int n;
				char c;
				string* s;
			} val;
		} CONST;
		struct{
			pobject type;
			pobject param;
			bool err;
		}MC;
		struct{
			pobject type;
			pobject param;
			bool err;
			int n;
		} LE;
	}_;
}
%token <kind> NO_KIND_DEF_ VAR_ PARAM_ FUNCTION_ FIELD_ ARRAY_TYPE_ STRUCT_TYPE_ ALIAS_TYPE_ SCALAR_TYPE_  UNIVERSAL_

%right "then" ELSE // Same precedence, but "shift" wins.

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

T : INTEGER {$<type>$ = pInteger}
  | CHAR    {$<type>$ = pChar}
  | BOOLEAN {$<type>$ = pBool}
  | STRING  {$<type>$ = pString}
  | IDU     {$<type>$ = $<type>1};

/* Uma Declaração de Tipo (DT) pode ser uma declaração de um tipo vetor ou um tipo estrutura ou um tipo sinônimo.

DT : type IDD ASSIGN array LEFT_SQUARE NUM RIGHT_SQUARE OF T 
   | type IDD ASSIGN STRUCT LEFT_BRACES DC RIGHT_BRACES 
   | type IDD ASSIGN T ;

DC : DC SEMI_COLON LI COLON T 
   | LI COLON T ;

/* Uma Declaração de Função é formada pela palavra ‘function’ seguida pelo nome da função (ID) seguida da Lista de Parâmetros (LP) entre parênteses seguida por ‘:’ e pelo Tipo (T) de retorno seguido pelo Bloco (B): */

DF : FUNCTION IDD LEFT_PARENTHESIS LP RIGHT_PARENTHESIS COLON T B {
   $<type>$ = $<type>7
};

LP : LP COMMA IDD COLON T 
   | IDD COLON T
   |  ;

/* Um Bloco (B) é delimitado por chave e contém uma Lista de Declaração de Variáveis (LDV) seguida por uma Lista de Statements (LS) ou Comandos: */

B : LEFT_BRACES LDV LS RIGHT_BRACES
  | LEFT_BRACES LS RIGHT_BRACES ; /* self modification */

LDV : LDV DV 
    | DV ;

LS : LS S 
   | S ;

/* Uma Declaração de Variáveis (DV) é formada pela palavra ‘var’ seguida por uma Lista de Identificadores (LI), separados por ‘,’, seguida de ‘:’ e do Tipo (T) das variáveis declaradas com um ‘;’ ao final. */

DV : VAR LI COLON T SEMI_COLON ;

LI : LI COMMA IDD
   | IDD ;

/* Um Statement (S) pode ser um comando de seleção, repetição, um bloco, uma atricbuição ou um comando de controle de fluxo de repetição (‘break’ ou ‘continue’): */

S : IF LEFT_PARENTHESIS E RIGHT_PARENTHESIS S %prec "then"
  | IF LEFT_PARENTHESIS E RIGHT_PARENTHESIS S ELSE S
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
  | IDU LEFT_PARENTHESIS LE RIGHT_PARENTHESIS 
  | MINUS F 
  | NOT 
  | TRUE 
  | FALSE
  | CHR
  | STR
  | NUM ;

LE : LE COMMA E
   | E ;

LV : LV DOT IDU
   | LV LEFT_SQUARE E RIGHT_SQUARE
   | IDU ;

IDD : id;
IDU : id;

TRUE: true {
	$<type>$ = pBool;
	$<val>$  = true;
};
FALSE: false {
	$<type>$ = pBool;
	$<val>$  = false;
};
CHR: chr {
	$<type>$ = pChar;
	$<pos>$  = tokenSecundario;
	$<val>$  = getCharConst(CHR.pos);
};
STR: str {
	$<type>$ = pString;
	$<pos>$ = tokenSecundario;
	$<val>$ = getStringConst(STR.pos);
};
NUM: num {
	$<type>$ = pInteger;
	$<pos>$  = tokenSecundario;
	$<val>$  = getIntConst(NUM.pos);
};

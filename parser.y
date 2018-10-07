%{
#include <stdio.h>
#include <string.h>
#include "./parser.tab.h"

 
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

%code requires{
#include "./helpers/object.h"
#include "./helpers/syntax.h"
#include "./helpers/attributes.h"

pobject p, t, f, t1, t2;

}

%token STRUCT OF COLON SEMI_COLON COMMA EQUALS LEFT_SQUARE RIGHT_SQUARE LEFT_BRACES RIGHT_BRACES LEFT_PARENTHESIS RIGHT_PARENTHESIS AND OR LESS_THAN GREATER_THAN LESS_OR_EQUAL GREATER_OR_EQUAL NOT_EQUAL EQUAL_EQUAL PLUS PLUS_PLUS MINUS MINUS_MINUS TIMES DIVIDE DOT NOT
%token TYPE RETURN ELSE BREAK WHILE VAR ASSIGN CONTINUE FUNCTION STRING IF BOOLEAN CHAR INTEGER DO
%token const_array const_char const_number const_string id const_true const_false
%token ERR_REDCL ERR_NO_DECL ERR_TYPE_EXPECTED ERR_BOOL_TYPE_EXPECTED ERR_TYPE_MISMATCH ERR_INVALID_TYPE ERR_KIND_NOT_STRUCT ERR_FIELD_NOT_DECL ERR_KIND_NOT_ARRAY ERR_INVALID_INDEX_TYPE ERR_KIND_NOT_VAR ERR_KIND_NOT_FUNCTION ERR_TOO_MANY_ARGS ERR_PARAM_TYPE ERR_TOO_FEW_ARGS ERR_RETURN_TYPE_MISMATCH

%union {
	int nont;
	union {
		struct {
			pobject obj;
			int name;
		} ID_;
		struct {
			pobject type;
		} T_,E_,L_,R_,TM_,F_,LV_;
		struct {
			pobject list;
		} LI_,DC_;
		struct{
			pobject list;
			int nSize;
		} LP_;
		struct{
			int val;
			pobject type;
		} BOOL_;
		struct {
			pobject type;
			int pos;
			union {
				int n;
				char c;
				char **s;
			} val;
		} CONST_;
		struct{
			pobject type;
			pobject param;
			int err;
		}MC_;
		struct{
			pobject type;
			pobject param;
			int err;
			int n;
		} LE_;
	}_;
}

%token <type> NT_TRUE NT_FALSE NT_CHR NT_STR NT_NUM MF MC
%token NO_KIND_DEF_ VAR_ PARAM_ FUNCTION_ FIELD_ ARRAY_TYPE_ STRUCT_TYPE_ ALIAS_TYPE_ SCALAR_TYPE_  UNIVERSAL_

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

T : INTEGER {
	$<nont>$ = T;
	$<_.T_.type>$ = pInt;
}
  | CHAR {
	$<nont>$ = T;
	$<_.T_.type>$ = pChar;
}
  | BOOLEAN {
	$<nont>$ = T;
	$<_.T_.type>$ = pBool;
}
  | STRING {
	$<nont>$ = T;
	$<_.T_.type>$ = pString;
}
  | IDU{
	p = $<_.ID_.obj>$;
	if (IS_TYPE_KIND(p->eKind) || p->eKind == UNIVERSAL_) {
		$<_.T_.type>$ = p;
	} else {
		$<_.T_.type>$ = pUniversal;
	}
	$<nont>$ = T;
};

/* Uma Declaração de Tipo (DT) pode ser uma declaração de um tipo vetor ou um tipo estrutura ou um tipo sinônimo. */

NB : {
  NewBlock();
};

DT : TYPE IDD ASSIGN const_array LEFT_SQUARE NUM RIGHT_SQUARE OF T 
   | TYPE IDD ASSIGN STRUCT NB LEFT_BRACES DC RIGHT_BRACES {
     EndBlock();
   }
   | TYPE IDD ASSIGN T ;

DC : DC SEMI_COLON LI COLON T 
   | LI COLON T ;

/* Uma Declaração de Função é formada pela palavra ‘function’ seguida pelo nome da função (ID) seguida da Lista de Parâmetros (LP) entre parênteses seguida por ‘:’ e pelo Tipo (T) de retorno seguido pelo Bloco (B): */

DF : FUNCTION IDD NB LEFT_PARENTHESIS LP RIGHT_PARENTHESIS COLON T B {
  EndBlock();
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

TRUE: const_true;
FALSE: const_false;
CHR: const_char;
STR: const_string;
NUM: const_number;
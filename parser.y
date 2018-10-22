%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./parser.tab.h"
#include "./helpers/shared.h"
#include "./helpers/code.h"
#define db(x) printf(#x);printf(": %d\n",x);


void yyerror(const char *error) {
    fprintf(stderr,"error: %s\n na linha %d",error,line);
}

int hadWarning = 0;

int yywrap() {
	if(hadWarning)
		puts("compilado com warnings!\n");
	else
		puts("compilado com sucesso!\n");
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
	struct {
		int nont;

		char *code;

		int endParentCheckpoint;
		int beginParentCheckpoint;

		int variableOrder;

		int nVariables;
		int nParams;
	} attr;

	union {
		struct {
			pobject obj;
			char* name;
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

P : LDE {
	printf("%s",$<attr.code>1);
};

LDE : LDE DE {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
		sprintf($<attr.code>$,"%s\n%s",$<attr.code>1,$<attr.code>2);
	}
    | DE {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
		sprintf($<attr.code>$, $<attr.code>1);
	};

/* Uma Declaração Externa (DE) é uma Declaração de Função (DF) ou uma Declaração de Tipo (DT) ou uma Declaração de Variáveis (DV): */

DE : DF {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$,$<attr.code>1);
}
	| DT {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
		sprintf($<attr.code>$,$<attr.code>1);
} ;

/* Um Tipo (T) pode ser a palavra ‘integer’ ou a palavra ‘char’ ou a palavra ‘boolean’ ou a palavra ‘string’ ou um ID representando um tipo previamente declarado: */

T : INTEGER {
	$<attr.nont>$ = T;
	$<_.T_.type>$ = pInt;
}
  | CHAR {
	$<attr.nont>$ = T;
	$<_.T_.type>$ = pChar;
}
  | BOOLEAN {
	$<attr.nont>$ = T;
	$<_.T_.type>$ = pBool;
}
  | STRING {
	$<attr.nont>$ = T;
	$<_.T_.type>$ = pString;
}
  | IDU{
	p = $<_.ID_.obj>$;
	if (IS_TYPE_KIND(p->eKind) || p->eKind == UNIVERSAL_) {
		$<_.T_.type>$ = p;
	} else {
		$<_.T_.type>$ = pUniversal;
	}
	$<attr.nont>$ = T;
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
	int n = getFunctionNumber();
	int p = $<attr.nParams>5;
	int v = $<attr.nParams>9;

		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$,"%s %d %d %d\n%s\n%s\n",
		"BEGIN_FUNC",n,p,v,
		$<attr.code>9,
		"END_FUNC");
};

LP : LP COMMA IDD COLON T {
	$<attr.nParams>$ = $<attr.nParams>1 + 1;
}
   | IDD COLON T {
	$<attr.nParams>$ = 1;
}
   | {
	$<attr.nParams>$ = 0;
} ;

/* Um Bloco (B) é delimitado por chave e contém uma Lista de Declaração de Variáveis (LDV) seguida por uma Lista de Statements (LS) ou Comandos: */

B : LEFT_BRACES LDV LS RIGHT_BRACES {
	$<attr.nParams>$ = $<attr.nParams>2;

		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$,"%s\n",$<attr.code>3);
}
  | LEFT_BRACES LS RIGHT_BRACES {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
		sprintf($<attr.code>$,$<attr.code>2);
		$<attr.nParams>$ = 0;
};

LDV : LDV DV {
	$<attr.nVariables>$ = $<attr.nVariables>1 + 1;
}
    | DV {
	$<attr.nVariables>$ = 1;
};

LS : LS S {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$,"%s\n%s",$<attr.code>1,$<attr.code>2);
}
   | S {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$,"%s",$<attr.code>1);
};

/* Uma Declaração de Variáveis (DV) é formada pela palavra ‘var’ seguida por uma Lista de Identificadores (LI), separados por ‘,’, seguida de ‘:’ e do Tipo (T) das variáveis declaradas com um ‘;’ ao final. */

DV : VAR LI COLON T SEMI_COLON ;

LI : LI COMMA IDD
   | IDD ;

/* Um Statement (S) pode ser um comando de seleção, repetição, um bloco, uma atricbuição ou um comando de controle de fluxo de repetição (‘break’ ou ‘continue’): */

S : IF LEFT_PARENTHESIS E RIGHT_PARENTHESIS S %prec "then" {
	int l1 = getCheckpoint();
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$,"%s\n%s%d\n%s\n%c%d%c\n",
		$<attr.code>3,
		"TJMP L",l1,
		$<attr.code>5,
		'L',l1,':');
}
  | IF LEFT_PARENTHESIS E RIGHT_PARENTHESIS S ELSE S {
	int l1 = getCheckpoint();
	int l2 = getCheckpoint();
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$,"%s\n%s%d\n%s\n%c%d%c\n%s\n%c%d%c",
		$<attr.code>3,
		"TJMP L",l1,
		$<attr.code>5,
		'L',l1,':',
		$<attr.code>7,
		'L',l2,':');
}
  | WHILE LEFT_PARENTHESIS E RIGHT_PARENTHESIS S {
	int l1 = getCheckpoint();
	int l2 = getCheckpoint();

		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$,"%c%s%c\n%s\n%s%d\n%s\n%s%d\n%c%d%c\n",
		'L',l1,':',
		$<attr.code>4,
		"TJMP L",l2,
		$<attr.code>5,
		"JMP L",l1,
		'L',l2,':');

	$<attr.beginParentCheckpoint>5 = l1;
	$<attr.endParentCheckpoint>5 = l2;
}
  | DO S WHILE LEFT_PARENTHESIS E RIGHT_PARENTHESIS SEMI_COLON {
	int l1 = getCheckpoint();
	int l2 = getCheckpoint();
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$,"%c%d%c\n%s\n%s\n%s\n%s\n%d\n%c%d%c",
		'L',l1,':',
		$<attr.code>2,
		$<attr.code>5,
		"NOT",
		"TJMP L",l1,
		'L',l2,':');

	$<attr.beginParentCheckpoint>5 = l1;
	$<attr.endParentCheckpoint>5 = l2;
}
  | B {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$,$<attr.code>1);
}
  | LV ASSIGN E SEMI_COLON
  | BREAK SEMI_COLON {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$,"JMP L%d",$<attr.endParentCheckpoint>$);
  }
  | CONTINUE SEMI_COLON {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$,"JMP L%d",$<attr.beginParentCheckpoint>$);
  }
  | RETURN E SEMI_COLON {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
		sprintf($<attr.code>$,"TESTELOKO");
  };
  
/* Uma Expressão (E) pode ser composta por operadores lógicos, relacionais ou aritméticos, além de permitir o acesso aos componentes dos tipos agregados e da atribuição de valores: */

E : E AND L {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$,"%s\n%s\n%s",
		$<attr.code>1,
		$<attr.code>3,
		"AND");	
}
  | E OR L {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$,"%s\n%s\n%s",
		$<attr.code>1,
		$<attr.code>3,
		"OR");
  }
  | L {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	  sprintf($<attr.code>$, "%s",
	  	$<attr.code>1);
  } ;

L : L LESS_THAN R {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$, "%s\n%s\n%s",
		$<attr.code>1,
		$<attr.code>3,
		"LT");
}
  | L GREATER_THAN R {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$, "%s\n%s\n%s",
		$<attr.code>1,
		$<attr.code>3,
		"GT");
  }
  | L LESS_OR_EQUAL R {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$, "%s\n%s\n%s",
		$<attr.code>1,
		$<attr.code>3,
		"LE");
  }
  | L GREATER_OR_EQUAL R {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$, "%s\n%s\n%s",
		$<attr.code>1,
		$<attr.code>3,
		"GE");
  }
  | L EQUALS R {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$, "%s\n%s\n%s",
		$<attr.code>1,
		$<attr.code>3,
		"EQ");
  }
  | L NOT_EQUAL R {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$, "%s\n%s\n%s",
		$<attr.code>1,
		$<attr.code>3,
		"NE");
  }
  | R {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$, "%s",
		$<attr.code>1);
  } ;

R : R PLUS Y {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$, "%s\n%s\n%s",
		$<attr.code>1,
		$<attr.code>3,
		"ADD");
}
  | R MINUS Y {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$, "%s\n%s\n%s",
		$<attr.code>1,
		$<attr.code>3,
		"SUB");
  }
  | Y {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$, "%s",
		$<attr.code>1);
  } ;

Y : Y TIMES F {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$, "%s\n%s\n%s",
		$<attr.code>1,
		$<attr.code>3,
		"MUL");
}
  | Y DIVIDE F {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$, "%s\n%s\n%s",
		$<attr.code>1,
		$<attr.code>3,
		"DIV");
  }
  | F {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$, "%s\n",
		$<attr.code>1);
  } ;

F : LV {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
		sprintf($<attr.code>$, "%s\n%s%d\n",
		$<attr.code>1,
		"DE_REF", 
		$<attr.variableOrder>$);	
	}
  | PLUS_PLUS LV {
		// yellow sign
	$<attr.variableOrder>$ = 1;
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	sprintf($<attr.code>$,"%s\n%s\n%s%d\n%s\n%s%d\n%s%d",
		$<attr.code>2,
		"DUP",
		"DUP",
		"DE_REF ",$<attr.variableOrder>$,
		"INC",
		"STORE_REF ",$<attr.variableOrder>$,
		"DE_REF ",$<attr.variableOrder>$);
}
  | MINUS_MINUS LV 
	{
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
		sprintf($<attr.code>$, "%s\n%s\n%s\n%s\n%s\n%s\n%s",
		$<attr.code>2,		
		"DUP",
		"DUP",
		"DE_REF 1", 
		"DEC",
		"STORE_REF",
		"DE_REF 1");	
	}
  | LV PLUS_PLUS 
	{
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
		sprintf($<attr.code>$, "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s",
		$<attr.code>2,		
		"DUP",
		"DUP",
		"DE_REF 1", 
		"INC",
		"STORE_REF",
		"DE_REF 1",
		"DEC");	
	}
  | LV MINUS_MINUS {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
		sprintf($<attr.code>$, "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s",
		$<attr.code>2,		
		"DUP",
		"DUP",
		"DE_REF 1", 
		"DEC",
		"STORE_REF",
		"DE_REF 1",
		"INC");	
	}
  | LEFT_PARENTHESIS E RIGHT_PARENTHESIS 
  | IDU LEFT_PARENTHESIS LE RIGHT_PARENTHESIS 
  | MINUS F {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	  sprintf($<attr.code>$, "%s\n%s\n",
	  	$<attr.code>2,
		"NEG");
  }
  | NOT F {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	  sprintf($<attr.code>$, "%s\n%s\n",
	  	$<attr.code>2,
		"NOT");
  }
  | TRUE {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	  sprintf($<attr.code>$, "%s\n",
		"LOAD_TRUE");
  }
  | FALSE {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	  sprintf($<attr.code>$, "%s\n",
		"LOAD_FALSE");
  }
  | CHR {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	  int n = getConstantNumber();
	  sprintf($<attr.code>$, "LOAD_CONST %d\n", n);
  }
  | STR {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	  int n = getConstantNumber();
	  sprintf($<attr.code>$, "LOAD_CONST %d\n", n);
  }
  | NUM {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
	  int n = getConstantNumber();
	  sprintf($<attr.code>$, "LOAD_CONST %d\n", n);
  } ;

LE : LE COMMA E {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
		sprintf($<attr.code>$, "%s\n%s\n", $<attr.code>1, $<attr.code>3);
	}
  | E {
		$<attr.code>$ = (char*) malloc(500*sizeof(char));
		sprintf($<attr.code>$, "%s\n", $<attr.code>1);		 		 		 		 		 
	} ;

LV : LV DOT IDU
   | LV LEFT_SQUARE E RIGHT_SQUARE
   | IDU {
		 // TODO
   };

IDD : id {
  $<_.ID_.name>$ = ids[currentLevel][secondaryToken].name;
  if( ids[currentLevel][secondaryToken].count  > 1 ) {
    printf("scope error: trying to redefine\n");
		exit(1);
  }
};

IDU : id {
  char *name =ids[currentLevel][secondaryToken].name;
  $<_.ID_.name>$ = name;
  if( searchName( name ) == -1 ) {
        printf("scope warning: trying to use unexisting %s\n",name);
		hadWarning = 1;
        addName(name);
  }
};

TRUE: const_true;
FALSE: const_false;
CHR: const_char;
STR: const_string;
NUM: const_number {};

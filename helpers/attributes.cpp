#include<list>
#include<iostream>
#include "../parser.tab.h"
#include "./attributes.h"

using namespace std;

int hasError = 0;

list<YYSTYPE> StackSem;

void Error(yytokentype code){
    hasError = true;
    //cout << "Linha: " << yylloc << " - ";
    switch(code){
        case ERR_NO_DECL:
            std::cout << "Variavel nao declarada";
            break;
        case ERR_REDCL:
            std::cout << "Variavel ja foi declarada";
            break;
        case ERR_TYPE_EXPECTED:
            std::cout << "Type Expected: Um tipo nao foi declarado anteriormente";
            break;
        case ERR_BOOL_TYPE_EXPECTED:
            std::cout << "Bool Expected: Um tipo booleano e esperado para expressao";
            break;
        case ERR_INVALID_TYPE:
            std::cout << "Invalid Type: O tipo e invalido para a operacao";
            break;
        case ERR_TYPE_MISMATCH:
            std::cout << "Type Mismatch: O tipo e invalido para a operacao";
            break;
        case ERR_KIND_NOT_STRUCT:
            std::cout << "Kind not Struct: A operacao so pode ser realizada em tipos Struct";
            break;
        case ERR_FIELD_NOT_DECL:
            std::cout << "Field not Declared: O campo nao foi declarado na estrutura";
            break;
        case ERR_KIND_NOT_ARRAY:
            std::cout << "Kind not Array: A operacao so pode ser realizada para um Array";
            break;
        case ERR_INVALID_INDEX_TYPE:
            std::cout << "Invalid Index: O Indice especificado para o Array e invalido";
            break;
        case ERR_KIND_NOT_VAR:
            std::cout << "Kind not Var: A operacao so e valida com tipos Var";
            break;
        case ERR_KIND_NOT_FUNCTION:
            std::cout << "Kind not Function: A operacao so e valida com tipos Function";
            break;
        case ERR_TOO_FEW_ARGS:
            std::cout << "Too Few Args: O numero de parametros especificado nao e suficiente";
            break;
        case ERR_TOO_MANY_ARGS:
            std::cout << "Too Many Args: O numero de parametros especificado e maior que o especificado";
            break;
        case ERR_PARAM_TYPE:
            std::cout << "Param Type: O tipo especificado para o parametro e invalido";
            break;
        default:
            break;
    }
    std::cout << std::endl;
}

bool CheckTypes(pobject t1,pobject t2){
    if(t1 == t2){
        return true;
    }
    else if(t1 == pUniversal || t2 == pUniversal){
        return true;
    }
    else if(t1->eKind == UNIVERSAL_ || t2->eKind == UNIVERSAL_){
        return true;
    }
    else if(t1->eKind == ALIAS_TYPE_ && t2->eKind != ALIAS_TYPE_){
        return CheckTypes(t1->_.Alias.pBaseType,t2);
    }
    else if(t1->eKind != ALIAS_TYPE_ && t2->eKind == ALIAS_TYPE_){
        return CheckTypes(t1,t2->_.Alias.pBaseType);
    }
    else if(t1->eKind == t2->eKind){
        //alias
        if(t1->eKind == ALIAS_TYPE_){
            return CheckTypes(t1->_.Alias.pBaseType,t2->_.Alias.pBaseType);
        }
        //array
        else if(t1->eKind == ARRAY_TYPE_){
            if(t1->_.Array.nNumElems == t2->_.Array.nNumElems){
                return CheckTypes(t1->_.Array.pElemType,t2->_.Array.pElemType);
            }
        }
        //struct
        else if(t1->eKind == STRUCT_TYPE_){
            pobject f1 = t1->_.Struct.pFields;
            pobject f2 = t2->_.Struct.pFields;
            
            while( f1 != NULL && f2 != NULL){
                if( ! CheckTypes(f1->_.Field.pType,f2->_.Field.pType)){
                    return false;
                }
            }
            return (f1 == NULL && f2 == NULL);
        }
    }
    
    return false;
}

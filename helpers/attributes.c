#include "../parser.tab.h"
#include "./attributes.h"

int hasError = 0;

object int_ =      { -1, 0, SCALAR_TYPE_ };  pobject pInt = &int_;
object char_ =     { -1, 0, SCALAR_TYPE_ };  pobject pChar = &char_;
object bool_ =     { -1, 0, SCALAR_TYPE_ };  pobject pBool = &bool_;
object string_ =   { -1, 0, SCALAR_TYPE_ };  pobject pString = &string_;
object universal_= { -1, 0, SCALAR_TYPE_ };  pobject pUniversal = &universal_;

int CheckTypes(pobject t1,pobject t2){
    if(t1 == t2){
        return 1;
    }
    else if(t1 == pUniversal || t2 == pUniversal){
        return 1;
    }
    else if(t1->eKind == UNIVERSAL_ || t2->eKind == UNIVERSAL_){
        return 1;
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
            
            while( f1 != 0 && f2 != 0){
                if( ! CheckTypes(f1->_.Field.pType,f2->_.Field.pType)){
                    return 0;
                }
            }
            return (f1 == 0 && f2 == 0);
        }
    }
    
    return 0;
}
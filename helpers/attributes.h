#ifndef ATTRIBUTES_H
#define ATTRIBUTES_H

#include "./scope.h"
#include "../parser.tab.h"

#define MAX_NEST_LEVEL 50
#define IS_TYPE_KIND(k) ((k)==ARRAY_TYPE_ || \
                         (k)==STRUCT_TYPE_|| \
                         (k)==ALIAS_TYPE_ || \
                         (k)==SCALAR_TYPE_)
void Error(int code);

object int_ =      { -1, 0, SCALAR_TYPE_ };  pobject pInt = &int_;
object char_ =     { -1, 0, SCALAR_TYPE_ };  pobject pChar = &char_;
object bool_ =     { -1, 0, SCALAR_TYPE_ };  pobject pBool = &bool_;
object string_ =   { -1, 0, SCALAR_TYPE_ };  pobject pString = &string_;
object universal_= { -1, 0, SCALAR_TYPE_ };  pobject pUniversal = &universal_;

#endif

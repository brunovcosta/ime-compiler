#ifndef ATTRIBUTES_H
#define ATTRIBUTES_H

#include "./scope.h"

#define MAX_NEST_LEVEL 50
#define IS_TYPE_KIND(k) ((k)==ARRAY_TYPE_ || \
                         (k)==STRUCT_TYPE_|| \
                         (k)==ALIAS_TYPE_ || \
                         (k)==SCALAR_TYPE_)
void Error(int code);



extern object int_;  extern pobject pInt;
extern object char_;  extern pobject pChar;
extern object bool_;  extern pobject pBool;
extern object string_;  extern pobject pString;
extern object universal_;  extern pobject pUniversal;
#endif

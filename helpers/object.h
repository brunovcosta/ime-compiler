#ifndef OBJECT_H
#define OBJECT_H

typedef struct object
{
    int nName;
    struct object *pNext;
    int eKind;
    
    union {
        struct {
            struct object *pType;
        } Var, Param, Field;
        struct {
            struct object *pRetType;
            struct object *pParams;
            int nParams;
        } Function;
        struct {
            struct object *pElemType;
            int nNumElems;
        } Array;
        struct {
            struct object *pFields;
        } Struct;
        struct {
            struct object *pBaseType;
        } Alias,Type;
    }_;
    
} object, *pobject;
#endif
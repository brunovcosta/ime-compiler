# IME Compiler

## Requirements
 - make
 - bison3
 - clang/gcc

### Installing bison 3 in MacOSX
```
brew install bison
brew link bison --force
```
## Usage
MacOSX/Linux
```
make
```
run examples
```
$ ./simple_script_language < examples/correct
compilado com sucesso!
```

```
$ ./simple_script_language < examples/wrong_lexer
lexer error: invalid character
```

```
$ ./simple_script_language < examples/wrong_parser
error: syntax error
 na linha 2
```

```
$ ./simple_script_language < examples/wrong_scope_error
scope warning: trying to use unexisting
scope warning: trying to use unexisting
scope error: trying to redefine
```

```
$ ./simple_script_language < examples/wrong_scope_warning
scope warning: trying to use unexisting
scope warning: trying to use unexisting
scope warning: trying to use unexisting
compilado com warnings!
```
## Files

### source code
 - parser.y
 - lexer.l
 - helpers/attributes.c
 - helpers/attributes.h
 - helpers/object.h
 - helpers/scope.c
 - helpers/scope.h
 - helpers/shared.h
 - helpers/syntax.h
 - Makefile
 - README.md

### generated code
 - bison.c
 - lex.c
 - lex.o
 - lex.yy.c
 - lexer.l
 - parser.tab.c
 - parser.tab.h
 - parser.y
 - tok.h

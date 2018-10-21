# Makefile

OBJS = bison.o lex.o scope.o attributes.o code.o

CC = cc
CFLAGS = -g

simple_script_language: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o simple_script_language

lex.o: lex.c
	$(CC) $(CFLAGS) -c lex.c -o lex.o

scope.o: helpers/scope.c
	$(CC) $(CFLAGS) -c helpers/scope.c -o scope.o

attributes.o: helpers/attributes.c
	$(CC) $(CFLAGS) -c helpers/attributes.c -o attributes.o

code.o: helpers/code.c
	$(CC) $(CFLAGS) -c helpers/code.c -o code.o

lex.c: lexer.l 
	flex lexer.l
	cp lex.yy.c lex.c

bison.o: bison.c
	$(CC) $(CFLAGS) -c bison.c -o bison.o

bison.c: parser.y
	bison -d -v parser.y
	cp parser.tab.c bison.c
	cmp -s parser.tab.h tok.h || cp parser.tab.h tok.h

clean:
	rm -f *.o *~ lex.c lex.yy.c bison.c tok.h parser.tab.c parser.tab.h parser.output simple_script_language attributes.o code.o

test:
	make clean;
	make;
	./simple_script_language < examples/correct

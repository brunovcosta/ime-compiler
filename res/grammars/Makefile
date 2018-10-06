# Makefile

OBJS	= bison.o lex.o

CC	= cc
CFLAGS	= -g

simple_script_language:		$(OBJS)
		$(CC) $(CFLAGS) $(OBJS) -o simple_script_language

lex.o:		lex.c
		$(CC) $(CFLAGS) -c lex.c -o lex.o

lex.c:		simple_script_language.l 
		flex simple_script_language.l
		cp lex.yy.c lex.c

bison.o:	bison.c
		$(CC) $(CFLAGS) -c bison.c -o bison.o

bison.c:	simple_script_language.y
		bison -d -v simple_script_language.y
		cp simple_script_language.tab.c bison.c
		cmp -s simple_script_language.tab.h tok.h || cp simple_script_language.tab.h tok.h

clean:
	rm -f *.o *~ lex.c lex.yy.c bison.c tok.h simple_script_language.tab.c simple_script_language.tab.h simple_script_language.output calc

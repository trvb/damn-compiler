CC = gcc
CFLAGS =-std=c99 -g
INC=~/flex/libfl.a

all : compiler
lex.yy.c : compiler.l
	~/flex/flex compiler.l
rule.tab.c : rule.y
	~/bison/bin/bison -d -v rule.y
symbol_table.o: symbol_table.c
	$(CC) $(CFLAGS) -c symbol_table.c
compiler : lex.yy.c rule.tab.c symbol_table.o
	$(CC) $(CFLAGS) lex.yy.c rule.tab.c -o compiler $(INC) symbol_table.o
clean:
	rm -rf compiler lex.yy.c rule.tab.c *.o
test:
	./compiler < test.c

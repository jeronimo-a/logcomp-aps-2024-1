analyzer:lexer.l parser.y
	bison -d parser.y
	flex lexer.l
	cc -o $@ parser.tab.c lex.yy.c -lfl
	rm lex.yy.c
	rm parser.tab.c
	rm parser.tab.h

parser: lex.yy.c y.tab.c
	gcc -o parser lex.yy.c y.tab.c -lfl

lex.yy.c: scanner.l y.tab.h
	flex scanner.l

y.tab.h y.tab.c: parser.y
	byacc -d parser.y

clean:
	rm lex.yy.c parser y.tab.h y.tab.c
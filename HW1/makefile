scanner: lex.yy.c
	gcc -o scanner lex.yy.c -lfl

lex.yy.c: scanner.l
	flex scanner.l

clean:
	rm lex.yy.c scanner
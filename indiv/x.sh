rm -f y.* a.out lex.yy.c
lex app.l
yacc -d app.y
cc *.c -o app

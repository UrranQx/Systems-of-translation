rm -f y.* lex.yy.c app2
yacc -vtd app.y
lex app.l
# yacc -d app.y
cc *.c -o app2

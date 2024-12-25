rm -f y.* a.out lex.yy.c
#yacc: if debug not needed, invoke with -d only
#yacc -d *.y
yacc -vtd c4.y
#lex: option -s to supress default action ECHO
lex -s c4.l
cc *.c -lm



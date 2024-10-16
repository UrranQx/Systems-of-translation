%%
e([abcd]x|([sd]i))  { ECHO; printf( "\n" ); }
.|\n       ;
%%

#include "yy.c"


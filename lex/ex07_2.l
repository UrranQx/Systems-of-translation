%{
void skip_comments();
%}

D   [0-9]
H   [0-9A-Fa-f]
L   [_A-Za-z]

%%
{L}({L}|{D})*   printf( "ident: %s\n", yytext );
0{H}+(H|h)?     |
{D}{H}*(H|h)    printf( "hex: %s\n", yytext );
{D}+            printf( "decimal: %s\n", yytext );
"/*"            skip_comments();
.               ;
%%

void skip_comments()
{
    int c = '*';	/* not char! */
    int MY_EOF = '\0'; /* Стандартный EOF не срабатывает. Даже если вводить через <C-D> */
    do {
      while ((c = input()) != '*' && c != MY_EOF);//; 
      //printf("\n23 line, c = %d, EOF = %d\n", c, MY_EOF);  
        if (c == MY_EOF) {
          fprintf(stderr, "?-EOF in comment\n");
          exit(1);
        }
        while ((c = input()) == '*');
    } while (c != '/' && c != MY_EOF);
    
}

#include "yy.c"


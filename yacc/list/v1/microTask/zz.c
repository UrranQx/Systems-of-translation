#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//#ifndef 
//extern int yydebug;
// Объявление yydebug как внешней переменной
//#endif

//
//extern int yydebug;      // Объявление yydebug
//extern int yyparse();   // Объявление yyparse
//
/* You can use "yyerror" for your own messages */
//yyerror(char *s) {
 //   fprintf(stderr, "?-%s\n", s);
//}

main() {
    return yyparse();
}

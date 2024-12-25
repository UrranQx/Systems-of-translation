%{
#include "y.tab.h"
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
%}

DIGIT       [0-9]
INTEGER     [-+]?{DIGIT}+
FRACTION    \.{DIGIT}+
FLOAT       [-+]?{DIGIT}+{FRACTION}?
DELIMITER   [,:;!?$]
WHITESPACE  [ \t]+

%%
{INTEGER}   { yylval.sval = strdup(yytext); return INTEGER_TOKEN; }
{FLOAT}     { yylval.sval = strdup(yytext); return FLOAT_TOKEN; }
{DELIMITER} { yylval.delimiter = yytext[0]; return DELIMITER_TOKEN; }
{WHITESPACE}+  ;
\n          { return NEWLINE; }
<<EOF>>     { return ENDFILE; }
.           { /* Игнорировать другие символы или выводить ошибку */ }
%%
int yywrap(void) {
    return 1;
}
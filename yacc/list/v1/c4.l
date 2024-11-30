%{
#include "y.tab.h"
#include <stdlib.h>
%}

%%
[+-]?[0-9]+(\.[0-9]+)? { yylval = atof(yytext); return NUM; }
[,:;!?$] { return yytext[0]; }
[ \t\n]+ ;  // Игнорируем пробелы и табуляции
. { return yytext[0]; }  // Возвращаем любой другой символ
%%


%{
#include "y.tab.h"
#include <stdio.h>
#include <string.h>
int line_num = 1;
int col_num = 1;
%}

%option noyywrap

%%
[+-]?[0-9]+(\.[0-9]+)? {
  yylval.dval = atof(yytext);
  col_num += strlen(yytext);
  return NUMBER;
}
[,:;!$?] {
  yylval.cval = yytext[0];
  col_num++;
  return DELIMITER;
}
[ \t]+ { col_num += strlen(yytext); } /* Игнорируем пробелы и табуляции */
\n { line_num++; col_num = 1; return NEWLINE; }
. {
  fprintf(stderr, "Error: Unexpected character '%c' at line %d, column %d\n", yytext[0], line_num, col_num);
  col_num++;
  return ERROR; // Новый токен для обработки ошибок
}
%%

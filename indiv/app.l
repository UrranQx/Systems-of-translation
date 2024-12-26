%{
#include "y.tab.h" // Заголовочный файл, сгенерированный YACC
#include <string.h>
#include <stdlib.h>
%}


%%

"unsigned"  return UNSUPPORTED_TYPE;
"void"      return VOID_TYPE; // Хотя мы не транслируем return, полезно его игнорировать
"char"      return CHAR;
"int"       return INT;
"float"     return FLOAT;
"double"    return DOUBLE;
"short"     return SHORT;
"long"      return LONG;
[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return IDENTIFIER; } 
[0-9][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return INVALID_IDENTIFIER; }
"("         return '(';
")"         return ')';
","         return ',';
"*"         return '*';
[ \t\n]+    ; // Игнорировать пробелы, табуляции и новые строки
.           { return yytext[0];}
%%
int yywrap(){
  return 1;

}

%{
#include "y.tab.h" // Заголовочный файл, сгенерированный YACC
#define YYSTYPE char*
extern YYSTYPE yyval;
%}


%%
"void"      return VOID_TYPE; // Хотя мы не транслируем return, полезно его игнорировать
"char"      return CHAR;
"int"       return INT;
"float"     return FLOAT;
"double"    return DOUBLE;
"short"     return SHORT;
"long"      return LONG;
[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return IDENTIFIER; }
"("         return '(';
")"         return ')';
","         return ',';
"*"         return '*';
[ \t\n]+    ; // Игнорировать пробелы, табуляции и новые строки
.           { /* Обработка неожиданных символов (можно выдать предупреждение) */ }
%%


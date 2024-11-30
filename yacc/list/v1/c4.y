%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int int_count = 0;
int float_count = 0;
int delimiter_count[5] = {0}; // Для [,:;!?$]

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
%}

%token NUM

%%
__list: _list '\n' { printf("Processed lines: 1\n"); }
      | __list _list '\n' { printf("Processed lines: %d\n", $1 + 1); }
      ;

_list: /* empty */ { $ = 0; }
      | list { $ = $1; }
      ;

list: NUM { 
          // Проверяем, является ли число целым или вещественным
          if (strchr(yytext, '.')) {
              float_count++;
          } else {
              int_count++;
          }
          $ = 1; 
      }
      | NUM ',' list { 
          // Обработка запятой
          if (strchr(yytext, '.')) {
              float_count++;
          } else {
              int_count++;
          }
          delimiter_count[0]++;
          $ = $3 + 1; 
      }
      | NUM ':' list { 
          // Обработка двоеточия
          if (strchr(yytext, '.')) {
              float_count++;
          } else {
              int_count++;
          }
          delimiter_count[1]++;
          $ = $3 + 1; 
      }
      | NUM ';' list { 
          // Обработка точки с запятой
          if (strchr(yytext, '.')) {
              float_count++;
          } else {
              int_count++;
          }
          delimiter_count[2]++;
          $ = $3 + 1; 
      }
      | NUM '!' list { 
          // Обработка восклицательного знака
          if (strchr(yytext, '.')) {
              float_count++;
          } else {
              int_count++;
          }
          delimiter_count[3]++;
          $ = $3 + 1; 
      }
      | NUM '?' list { 
          // Обработка вопросительного знака
          if (strchr(yytext, '.')) {
              float_count++;
          } else {
              int_count++;
          }
          delimiter_count[4]++;
          $ = $3 + 1; 
      }
      ;

%%

// Функция для получения индекса разделителя
int get_delimiter_index(char *delimiter) {
    if (strcmp(delimiter, ",") == 0) return 0;
    if (strcmp(delimiter, ":") == 0) return 1;
    if (strcmp(delimiter, ";") == 0) return 2;
    if (strcmp(delimiter, "!") == 0) return 3;
    if (strcmp(delimiter, "?") == 0) return 4;
    return -1; // Неизвестный разделитель
}

int main() {
    yyparse();
    printf("Total integers: %d\n", int_count);
    printf("Total floats: %d\n", float_count);
    printf("Delimiters count: [,:;!?$] -> [%d, %d, %d, %d, %d]\n", 
           delimiter_count[0], delimiter_count[1], delimiter_count[2], 
           delimiter_count[3], delimiter_count[4]);
    return 0;
}


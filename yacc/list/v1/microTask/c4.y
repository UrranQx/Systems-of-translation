%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int line_num; // Объявление внешней переменной line_num из lex
extern int yylineno; // для номер строки


extern int yylex();          // Объявление yylex
extern void yyerror(char *); // Объявление yyerror
extern int col_num;          // Объявление col_num
extern int line_num;        // Объявление line_num
int int_count = 0;
//int yydebug = 1;
//int int_count = 0;
int float_count = 0;
int comma_count = 0;
int semicolon_count = 0;
int doublecomma_count = 0;
int dollar_count = 0;
int exclamation_count = 0;
int question_count = 0;
int line_count = 0;
int error_count = 0;

void print_results();

%}

%union {
  double dval;
  char cval;
}

%token <dval> NUMBER
%token <cval> DELIMITER
%token NEWLINE
%token ERROR


%type <dval> num_list
%type <dval> num

%%

program:
  lines
  ;

lines:
  line lines
  |
  ;

line:
  num_list NEWLINE {
    line_count++;
    print_results();
    int_count = 0;
    float_count = 0;
    comma_count = 0;
    semicolon_count = 0;
    doublecomma_count = 0;
    dollar_count = 0;
    exclamation_count = 0;
    question_count = 0;
  }
  | error NEWLINE {
    fprintf(stderr, "Syntax error in line %d\n", line_num);
    yyerrok; // Сбрасываем флаг ошибки
    error_count++;
  }
  ;

num_list:
  num
  | num delimiter_seq num_list {
    $$ = $1; // Здесь можно было бы складывать числа, если нужно
  }
  ;

num:
  NUMBER {
    if ((int)$1 == $1) {
      int_count++;
    } else {
      float_count++;
    }
    $$ = $1;
  }
  ;

delimiter_seq:
  DELIMITER {
    int used[7] = {0}; // Массив для отслеживания использованных разделителей
    used[$1 - ','] = 1; // Отмечаем использованный разделитель
    switch ($1) {
      case ',': comma_count++; break;
      case ':': doublecomma_count++; break;
      case ';': semicolon_count++; break;
      case '$': dollar_count++; break;
      case '!': exclamation_count++; break;
      case '?': question_count++; break;
    }
  }
| DELIMITER DELIMITER {
    int used[7] = {0};
    used[$1 - ','] = 1;
    used[$2 - ','] = 1;

    //Проверка на дубликаты
    if (used[$1 - ','] == 2 || used[$2 - ','] == 2) {
        yyerror("Invalid delimiter pair: duplicate delimiters");
        YYERROR; //Принудительная остановка синтаксического анализатора
    }

    switch ($1) {
      case ',': comma_count++; break;
      case ':': dollar_count++; break;
      case ';': semicolon_count++; break;
      case '$': dollar_count++; break;
      case '!': exclamation_count++; break;
      case '?': question_count++; break;
    }
    switch ($2) {
      case ',': comma_count++; break;
      case ':': doublecomma_count++; break;
      case ';': semicolon_count++; break;
      case '$': dollar_count++; break;
      case '!': exclamation_count++; break;
      case '?': question_count++; break;
    }
  }
;

%%

void yyerror(char *s) {
    fprintf(stderr, "Error: %s at line %d, column %d\n", s, line_num, col_num);
}

void print_results() {
  printf("Processed lines: %d\n", line_count);
  printf("Integers: %d\n", int_count);
  printf("Floats: %d\n", float_count);
  printf("Commas: %d\n", comma_count);
  printf("Semicolons: %d\n", semicolon_count);
  printf("Double Commas: %d\n", dollar_count);
  printf("Dollars: %d\n", dollar_count);
  printf("Exclamation marks: %d\n", exclamation_count);
  printf("Question marks: %d\n", question_count);
  printf("Errors: %d\n", error_count);
  printf("\n");
}

//int main() {
//  yyparse();
//  return 0;
//}

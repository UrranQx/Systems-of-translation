%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Глобальные переменные для хранения статистики
int char_count = 0;
int int_count = 0;
int float_count = 0;
int double_count = 0;
int short_count = 0;
int long_count = 0;
int total_memory = 0;
int procedure_count = 0;

// Функция для подсчета размера типа данных
int get_type_size(int data_type) {
    switch (data_type) {
        case CHAR: return 1;
        case SHORT: return 2;
        case INT: return 2; // Предположение о 16-битной архитектуре
        case LONG: return 4;
        case FLOAT: return 4;
        case DOUBLE: return 8;
        default: return 0;
    }
}

// Функция для вывода директивы резервирования памяти
void output_memory_directive(char *identifier, int size) {
    printf("%s ", identifier);
    switch (size) {
        case 1: printf("db\n"); break;
        case 2: printf("dw\n"); break;
        case 4: printf("dd\n"); break;
        case 8: printf("dd 2 dup\n"); break;
        default: fprintf(stderr, "Ошибка: Неизвестный размер: %d\n", size);
    }
}

// Функция для вывода диагностического сообщения (пример YACC-сообщения)
void yyerror(const char *s) {
    fprintf(stderr, "Синтаксическая ошибка: %s\n", s);
}

int current_procedure_memory = 0;

%}

%union {
    int ival;   // Для хранения целых чисел (размеры типов)
    char *sval;  // Для хранения строк (идентификаторы)
}

%token <ival> CHAR INT FLOAT DOUBLE SHORT LONG
%token <sval> IDENTIFIER

%type <ival> data_type
%type <sval> identifier
%%

procedure_declarations: /* empty */
                     | procedure_declarations procedure_declaration
                         { procedure_count++;
                           printf("\n// Зарезервировано памяти для процедуры: %d байт\n", current_procedure_memory);
                           current_procedure_memory = 0;
                         }
                     ;

procedure_declaration: VOID_TYPE IDENTIFIER '(' parameter_list ')'
                     ;

parameter_list: /* empty */
              | parameter_declarations
              ;

parameter_declarations: parameter_declaration
                      | parameter_declarations ',' parameter_declaration
                      ;

parameter_declaration: data_type identifier
                       { output_memory_directive($2, $1);
                         total_memory += $1;
                         current_procedure_memory += $1;
                         switch ($1) {
                             case 1: char_count++; break;
                             case 2: if ($1 == $2 && !strcmp($2, "int")) int_count++; 
                                     else if ($1==$2 && !strcmp($2,"short")) short_count++;
                                     break;
                             case 4: float_count++; break;
                             case 8: double_count++; break;
                         }
                       }
                     | data_type '*' identifier
                       { output_memory_directive($3, 2); // Указатель занимает 2 байта
                         total_memory += 2;
                         current_procedure_memory += 2;
                       }
                     ;

data_type: CHAR  { $$ = get_type_size(CHAR); }
         | INT   { $$ = get_type_size(INT); }
         | FLOAT { $$ = get_type_size(FLOAT); }
         | DOUBLE { $$ = get_type_size(DOUBLE); }
         | SHORT { $$ = get_type_size(SHORT); }
         | LONG  { $$ = get_type_size(LONG); }
         ;

identifier: IDENTIFIER { $$ = $1; }
          ;

%%

int main() {
    extern FILE *yyin;
    yyin = stdin; // Чтение со стандартного ввода
    if (yyparse() == 0) {
        printf("\n// Статистика:\n");
        printf("// Объявлений char: %d\n", char_count);
        printf("// Объявлений int: %d\n", int_count);
        printf("// Объявлений float: %d\n", float_count);
        printf("// Объявлений double: %d\n", double_count);
        printf("// Объявлений short: %d\n", short_count);
        printf("// Объявлений long: %d\n", long_count);
        printf("// Общее количество зарезервированной памяти: %d байт\n", total_memory);
        printf("// Обработано объявлений процедур: %d\n", procedure_count);
        printf("// Трансляция завершена успешно.\n");
    } else {
        fprintf(stderr, "// Трансляция завершена с ошибками.\n");
    }
    return 0;
}

int yywrap() {
    return 1;
}

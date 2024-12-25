/* c.y */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Структура для хранения счетчиков для каждой строки
typedef struct {
    int integers;
    int floats;
    int comma;
    int colon;
    int semicolon;
    int exclamation;
    int question;
    int dollar;
} Counts;

Counts current_counts;
int line_count = 0;

// Структура для хранения общей статистики
Counts total_counts;

void reset_counts() {
    current_counts.integers = 0;
    current_counts.floats = 0;
    current_counts.comma = 0;
    current_counts.colon = 0;
    current_counts.semicolon = 0;
    current_counts.exclamation = 0;
    current_counts.question = 0;
    current_counts.dollar = 0;
}

void print_counts() {
    printf("Целых чисел: %d\n", current_counts.integers);
    printf("Вещественных чисел: %d\n", current_counts.floats);
    printf("Разделителей:\n");
    printf("  Запятая: %d\n", current_counts.comma);
    printf("  Двоеточие: %d\n", current_counts.colon);
    printf("  Точка с запятой: %d\n", current_counts.semicolon);
    printf("  Восклицательный знак: %d\n", current_counts.exclamation);
    printf("  Вопросительный знак: %d\n", current_counts.question);
    printf("  Знак доллара: %d\n", current_counts.dollar);
}

void update_total_counts() {
    total_counts.integers += current_counts.integers;
    total_counts.floats += current_counts.floats;
    total_counts.comma += current_counts.comma;
    total_counts.colon += current_counts.colon;
    total_counts.semicolon += current_counts.semicolon;
    total_counts.exclamation += current_counts.exclamation;
    total_counts.question += current_counts.question;
    total_counts.dollar += current_counts.dollar;
}

void print_total_counts() {
    printf("\n----- Общая статистика по всем строкам -----\n");
    printf("Всего целых чисел: %d\n", total_counts.integers);
    printf("Всего вещественных чисел: %d\n", total_counts.floats);
    printf("Всего разделителей:\n");
    printf("  Запятая: %d\n", total_counts.comma);
    printf("  Двоеточие: %d\n", total_counts.colon);
    printf("  Точка с запятой: %d\n", total_counts.semicolon);
    printf("  Восклицательный знак: %d\n", total_counts.exclamation);
    printf("  Вопросительный знак: %d\n", total_counts.question);
    printf("  Знак доллара: %d\n", total_counts.dollar);
}

int yylex();
void yyerror(const char *s);

%}

%union {
    char* sval;
    char delimiter;
}

%token <sval> INTEGER_TOKEN
%token <sval> FLOAT_TOKEN
%token <delimiter> DELIMITER_TOKEN
%token NEWLINE
%token ENDFILE
%token ERROR_TOKEN

%start input

%%

input: /* empty */
     | input line { line_count++; printf("Обработана строка %d:\n", line_count); print_counts(); update_total_counts();reset_counts(); }
     | input ENDFILE { printf("Всего обработано строк: %d\n", line_count); print_total_counts(); return 0; }
     ;

line: /* empty */ { reset_counts(); }
    | elements NEWLINE { }
    | error NEWLINE {
        yyerror("Синтаксическая ошибка в строке");
	reset_counts();
        yyclearin;
        yyerrok;
      }
    | error ENDFILE {
        yyerror("Синтаксическая ошибка в строке и конец файла");
        yyclearin;
        yyerrok;
      }
    ;

elements: element
        | elements element
        ;

element: number optional_delimiters
       ;

number: INTEGER_TOKEN { current_counts.integers++; free($1); }
      | FLOAT_TOKEN { current_counts.floats++; free($1); }
      ;

optional_delimiters: /* empty */
                     | single_delimiter
                     | double_delimiter
                     ;

single_delimiter: DELIMITER_TOKEN {
                    switch ($1) {
                        case ',': current_counts.comma++; break;
                        case ':': current_counts.colon++; break;
                        case ';': current_counts.semicolon++; break;
                        case '!': current_counts.exclamation++; break;
                        case '?': current_counts.question++; break;
                        case '$': current_counts.dollar++; break;
                    }
                  }
          ;

double_delimiter: DELIMITER_TOKEN DELIMITER_TOKEN {
    if ($1 == $2) {
        yyerror("Повторяющиеся разделители недопустимы");
    } else {
        switch ($1) {
            case ',': current_counts.comma++; break;
            case ':': current_counts.colon++; break;
            case ';': current_counts.semicolon++; break;
            case '!': current_counts.exclamation++; break;
            case '?': current_counts.question++; break;
            case '$': current_counts.dollar++; break;
        }
        switch ($2) {
            case ',': current_counts.comma++; break;
            case ':': current_counts.colon++; break;
            case ';': current_counts.semicolon++; break;
            case '!': current_counts.exclamation++; break;
            case '?': current_counts.question++; break;
            case '$': current_counts.dollar++; break;
        }
    }
}

%%

void yyerror(const char *s) {
    fprintf(stderr, "error: %s\n", s);
    // При ошибке пропускаем текущую строку
    int token;
    while ((token = yylex()) != NEWLINE && token != ENDFILE && token != 0) ;
}

int main() {
    // Инициализация общей статистики
    total_counts.integers = 0;
    total_counts.floats = 0;
    total_counts.comma = 0;
    total_counts.colon = 0;
    total_counts.semicolon = 0;
    total_counts.exclamation = 0;
    total_counts.question = 0;
    total_counts.dollar = 0;

    int result = yyparse();
    if (result == 0) {
        printf("Разбор завершен успешно.\n");
    } else {
        printf("Разбор завершен с ошибками.\n");
    }
    exit(result); // Явно завершаем программу
}
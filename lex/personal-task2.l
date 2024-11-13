%{
#include <stdio.h>
#include <stdlib.h>

int result = 0;
int current_number = 0;
char last_operator = '+';

void calculate() {
    if (last_operator == '+') {
        result += current_number;
    } else if (last_operator == '-') {
        result -= current_number;
    }
}
%}

D 0[dD][0-9]+
H 0[xX][0-9a-fA-F]+

%%

{D} {
    current_number = atoi(yytext + 2); // Пропускаем префикс "0d"
    calculate();
}

{H} {
    current_number = (int)strtol(yytext, NULL, 16);
    calculate();
}

"+" {
    last_operator = '+';
}
"-" {
    last_operator = '-';
}

[ \t]+ ;

\n {
    // Если строка завершена, выводим результат и завершаем программу
    printf("Результат в десятичной системе: %d\n", result);
    printf("Результат в шестнадцатеричной системе: %X\n", result);
    exit(0);
}

. {
    fprintf(stderr, "Ошибка: некорректный символ '%s'\n", yytext);
    fprintf(stderr, "Ошибка: неверный синтаксис.\n");
    exit(1);
}

%%

#ifndef yywrap
int yywrap() { return(1); }
#endif

int main() {
    printf("Введите арифметическое выражение: \nПример: 0d30 + 0d239 - 0d64\nПример: 0xf - 0xa\n");
    yylex(); // Запускаем лексический анализ
    return 0;
}


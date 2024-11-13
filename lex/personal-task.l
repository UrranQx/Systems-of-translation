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
D 0[dD][0-9]
H 0[xX][0-9a-fA-F]

%%

0[dD][0-9]+ {
// atoi - фунцкия в c, которая переводит число из текстового формата в int
// Распознавание десятичных чисел с префиксом 0d
    current_number = atoi(yytext + 2); // Пропускаем префикс "0d"
    calculate();
}

{H}+ {
    
// Определяем правила для распознавания шестнадцатеричных чисел с префиксом 0x
    current_number = (int)strtol(yytext, NULL, 16);
    calculate();
}

"+" {
    last_operator = '+';
}
"-" {
    last_operator = '-';
}

[ \t\n]+ ;
. {
    fprintf(stderr, "Ошибка: некорректный символ '%s'\n", yytext);
    fprintf(stderr, "Ошибка: неверный синтаксис.\n");
    exit(1);
}

%%
#ifndef yywrap
int yywrap() { return(1);}
#endif

main() {
    printf("Введите арифметическое выражение: \nПример: 0d30 + 0d239 - 0d64\nПример: 0xf - 0xa\n");
    yylex(); // Запускаем лексический анализ
    printf("Результат в десятичной системе: %d\n", result);
    printf("Результат в шестнадцатеричной системе: %X\n", result);
    return 0;
}

//#include "yy.c"

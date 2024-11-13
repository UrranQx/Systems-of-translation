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

%%
// atoi - фунцкия в c, которая переводит число из текстового формата в int
// Распознавание десятичных чисел с префиксом 0d
0[dD][0-9]+ {
    current_number = atoi(yytext + 2); // Пропускаем префикс "0d"
    calculate();
}

// Определяем правила для распознавания шестнадцатеричных чисел с префиксом 0x
0[xX][0-9a-fA-F]+ {
    current_number = (int)strtol(yytext, NULL, 16);
    calculate();
}

// Определяем правила для распознавания операторов
"+" {
    last_operator = '+';
}
"-" {
    last_operator = '-';
}

// Пропускаем пробелы
[ \t\n]+ { /* ничего не делаем */ }

// Обработка некорректных символов
. {
    fprintf(stderr, "Ошибка: некорректный символ '%s'\n", yytext);
    fprintf(stderr, "Ошибка: неверный синтаксис.\n");
    exit(1);
}

%%

// Основная функция
int main() {
    printf("Введите арифметическое выражение: \nПример: 0d30 + 0d239 - 0d64\nПример: 0xf - 0xa");
    yylex(); // Запускаем лексический анализ
    printf("Результат в десятичной системе: %d\n", result);
    printf("Результат в шестнадцатеричной системе: %X\n", result);
    return 0;
}


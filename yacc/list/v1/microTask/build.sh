#!/bin/bash

# Удаляем временные файлы
rm -f y.* a.out lex.yy.c

# Вызываем yacc
yacc -d c4.y

# Вызываем lex
lex -s  c4.l

# Компилируем
cc *.c

# Проверка на успешную компиляцию
if [ $? -eq 0 ]; then
  echo "Compilation successful!"
else
  echo "Compilation failed!"
fi

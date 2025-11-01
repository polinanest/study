#!/bin/bash


: '
Создайте скрипт, который выполняет следующие действия:
Читает данные из файла input.txt.
Перенаправляет вывод команды wc -l (подсчет строк) в файл output.txt.
Перенаправляет ошибки выполнения команды ls для несуществующего файла в файл error.log.
'

if [ -f "input.txt" ]; then
    echo "Содержимое input.txt:"
    cat input.txt
    echo "---"

    wc -l < input.txt > output.txt
    echo "Количество строк файла input записано в output.txt"


else
    echo "Файл input.txt не существует." >> error.log
    echo "Добавлена запись в файл логирования"
fi


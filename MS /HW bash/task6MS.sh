#!/bin/bash

read -p "Введите путь к директории: " directory

cd "$directory" || exit 1

file_count=$(find "$directory" -type f -mtime +7 | wc -l)


if [ "$file_count" -eq 0 ]; then
    echo "Файлов для удаления не найдено."
    exit 0
fi

echo "Удаление файлов..."
    find "$directory" -type f -mtime "+$days" -exec rm -v {} \;

echo "Удаление завершено. Удалено файлов: $file_count"

#!/bin/bash
read -p "Введите путь к директории: " directory
cd "$directory" || exit 1
for file in *; do
    if [ -f "$file" ]; then
        new_name="backup_$file"
        mv "$file" "$new_name"
        echo "Переименован: $file -> $new_name"
    fi
done

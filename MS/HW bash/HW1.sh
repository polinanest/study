: '
Напишите Bash-скрипт, который выполняет следующие действия:
Создаёт список всех файлов в текущей директории, указывая их тип (файл, каталог и т.д.).
Проверяет наличие определённого файла, переданного как аргумент скрипта, и выводит сообщение 
о его наличии или отсутствии.
Использует цикл for для вывода информации о каждом файле: его имя и права доступа.
'

echo "Текущая директория: $(pwd)"

read -p "Введите имя файла для проверки в текущей директории: " filename

if [ -e "$filename" ]; then
    echo "Файл '$filename' найден"

 if [ -f "$filename" ]; then
        echo "   Тип: Обычный файл"
    elif [ -d "$filename" ]; then
        echo "   Тип: Каталог"
    elif [ -L "$filename" ]; then
        echo "   Тип: Символическая ссылка"
    else
        echo "   Тип: Другой тип файла"
    fi


permissions=$(ls -ld "$filename" | awk '{print $1}')
    echo "   Права доступа: $permissions"
else
    echo "Файл '$filename' не существует в текущей директории"
fi


for file in *; do
    if [ -f "$file" ]; then
        file_type="Файл"
    elif [ -d "$file" ]; then
        file_type="Каталог"
    elif [ -L "$file" ]; then
        file_type="Ссылка"
    elif [ -b "$file" ]; then
        file_type="Блочное устройство"
    elif [ -c "$file" ]; then
        file_type="Символьное устройство"
    elif [ -p "$file" ]; then
        file_type="Канал (pipe)"
    elif [ -S "$file" ]; then
        file_type="Сокет"
    else
        file_type="Неизвестный тип"
    fi
    
    permissions=$(ls -ld "$file" | awk '{print $1}')
    
    printf "%-20s %-15s %-10s\n" "$file" "$file_type" "$permissions"
done




read -p "Введите путь к директории для архивирования: " source_dir
current_date=$(date +%Y-%m-%d)
dir_name=$(basename "$source_dir")
archive_name="${dir_name}_backup_${current_date}.tar.gz"
tar -czf "$archive_name" -C "$(dirname "$source_dir")" "$(basename "$source_dir")"
echo "Архив создан: $archive_name"

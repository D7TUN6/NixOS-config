# Функция для обработки файлов и директорий
process_path() {
    local path="$1"
    
    for item in "$path"/*; do
        if [ -d "$item" ]; then
            # Если это директория - рекурсивно обрабатываем
            process_path "$item"
        elif [ -f "$item" ]; then
            # Если это файл - выводим имя и содержимое
            echo "Файл: $item"
            echo "Содержимое:"
            cat "$item"
            echo "----------------------------------------"
        fi
    done
}

# Запускаем обход с текущей директории
process_path "."

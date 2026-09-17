#!/bin/sh

LOG="/tmp/crt-debug.log"
echo "=== старт дебаг-демона $(date) ===" > "$LOG"

# проверяем, доступен ли niri ipc
if ! niri msg session-info >/dev/null 2>&1; then
    echo "ошибка: niri ipc недоступен из этого окружения" >> "$LOG"
fi

# слушаем поток и пишем всё в лог
niri msg --json event-stream 2>> "$LOG" | while read -r line; do
    echo "получен ивент: $line" >> "$LOG"
    
    # проверяем, реагирует ли скрипт на структуру json
    if echo "$line" | grep -q -e "Output" -e "Monitor" -e "Workspace"; then
        echo "триггер сработал, пытаемся перезапустить сервис..." >> "$LOG"
        
        # пишем выхлоп systemctl прямо в лог
        run0 systemctl restart crt-init-color.service >> "$LOG" 2>&1
        echo "статус команды: $?" >> "$LOG"
    fi
done

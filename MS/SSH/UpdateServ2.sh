ssh -p 2222 root@localhost "
    echo 'Обновление списка пакетов...'
    apt update
    
    echo 'Установка обновлений...'
    apt upgrade -y
    
    if [ -f /var/run/reboot-required ]; then
        echo 'Обновления установлены. Требуется перезагрузка сервера!'
    else
        echo 'Обновления успешно установлены.'
    fi
"

#!/bin/bash
load=$(ssh -p 2222 root@localhost "uptime | awk '{print \$10}' | tr -d ',' | cut -d. -f1")

echo "Нагрузка: $load"

if [ $load -gt 5 ]; then
    echo "Слишком высокая нагрузка на процессор"
    ssh -p 2222 root@localhost "pkill -f 'python|node|java' 2>/dev/null || true"
else
    echo "Нормально"
fi

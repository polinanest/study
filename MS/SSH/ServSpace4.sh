#!/bin/bash
use=$(ssh -p 2222 root@localhost "df / | tail -1 | awk '{print \$5}'")
echo "Использовано диска: $use"
if [ ${use%\%} -gt 80 ]; then
    echo "Мало места на диске!"
fi

#!/bin/bash

read -p "Введите путь к папке на сервере, которую необходимо скопировать " folder
ssh -p 2222 root@localhost "cd '$folder' && tar -czf /tmp/backup.tar.gz ."
scp -P 2222 root@localhost:/tmp/backup.tar.gz .

mkdir -p "${folder##*/}"
tar -xzf backup.tar.gz -C "${folder##*/}"

echo "Папка '$folder' скопирована."

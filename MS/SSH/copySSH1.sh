#!/bin/bash

echo -n "Введите путь к папке для бэкапа: "
read SOURCE

tar -czf backup.tar.gz "$SOURCE"
scp -P 2222 backup.tar.gz root@localhost:/root/
ssh -p 2222 root@localhost "cd /root && ls -t backup*.tar.gz | tail -n +4 | xargs rm -f"
rm backup.tar.gz

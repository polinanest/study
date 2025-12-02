#!/bin/bash

rsync -avz -e "ssh -p 2222" ./ root@localhost:/home/sync/
rsync -avz -e "ssh -p 2222" root@localhost:/home/sync/ ./
echo "Синхронизация завершена"

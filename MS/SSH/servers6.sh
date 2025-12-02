#!/bin/bash
CMD="$1"
LOG="output.log"

while IFS= read -r server; do
    echo "=== $server ===" >> "$LOG"
    ssh -p 2222 "$server" "bash -lc $(printf '%q' "$CMD")" >> "$LOG" 2>&1
    echo "" >> "$LOG"
done < servers.txt

echo "Лог в $LOG"

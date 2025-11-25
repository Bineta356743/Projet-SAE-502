#!/bin/bash

backup_src="/data/source/"
backup_dest="/data/backups/"
backup_server="backup_server"
log_file="/var/log/backup.log"
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

# Sauvegarde
result=$(rsync -avz -e "ssh -o StrictHostKeyChecking=no" $backup_src root@$backup_server:$backup_dest 2>&1)
status=$?

# Log
if [ $status -eq 0 ]; then
    echo "[$timestamp] BACKUP OK - $result" >> $log_file
else
    echo "[$timestamp] BACKUP FAILED - $result" >> $log_file
fi

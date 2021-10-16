#!/bin/bash

SERVEUR='192.168.0.47'
BACKUP='/root/backup'
BACKUPDATE=$(date +"%Y%m%d-%H%M")

[ ! -d $BACKUP ] && mkdir $BACKUP && chown 0.0 $BACKUP && chmod 600 $BACKUP

echo "Dump SQL..."
ssh root@$SERVEUR "
mysqldump --defaults-extra-file=/etc/mysqldump.cnf --host=localhost \
--add-drop-table --add-locks --complete-insert \
wordpress | gzip -q5 > /root/tmp/wordpress.sql.gz
"

echo "Archive"
scp -p22 root@$SERVEUR:/root/tmp/wordpress.sql.gz $BACKUP/wordpress-"$BACKUPDATE".sql.gz
ssh root@$SERVEUR "rm /root/tmp/wordpress.sql.gz"


find $BACKUP -maxdepth 1 -type f -name  'wordpress-*.sql.gz' -mtime +30 | xargs rm -vf


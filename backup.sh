#!/bin/sh

BACKUP=backup.sql

if [ ! -f "$BACKUP" ]
then
    touch $BACKUP
fi

mysqldump -u root hoyoswelch -r $BACKUP

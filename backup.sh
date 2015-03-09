#!/bin/sh

BACKUP=backup.sql

if [ ! -f "$BACKUP" ]
then
    touch $BACKUP
fi

$BACKUP < mysqldump -u root hoyoswelch

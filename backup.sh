#!/bin/sh

LOG=backup_log

if [ ! -f "$LOG" ]
then
    touch $LOG
fi

echo "backup" >> $LOG

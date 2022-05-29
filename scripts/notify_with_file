#/bin/bash
DATE=`date "+%Y-%m-%d"`
HOSTNAME=`hostname`

cat "$1" | mail -s "DONE: $HOSTNAME $1 $DATE" s@martinien.de

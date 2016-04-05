#!/bin/sh

LOCKFILE=/var/run/backup_postgresql.pid
BACKUP_NAME=/backup/postgres_`date '+%Y%m%d'`.sql.gz

#
# script below
#

echo "backup started"

if [ -e $BACKUP_NAME ]; then
	echo "backup already exists"
	exit
fi

# lock script
if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; then
  echo "already running"
  exit
fi

# make sure the lockfile is removed when we exit and then claim it
trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
echo $$ > ${LOCKFILE}

echo "${POSTGRES_HOST}:${POSTGRES_PORT}:${POSTGRES_DB}:${POSTGRES_USER}:${POSTGRES_PASSWORD}" > /root/.pgpass
chmod 600 /root/.pgpass

pg_dump -C -h ${POSTGRES_HOST} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} ${POSTGRES_DB} | gzip -9 > ${BACKUP_NAME}
if [ $? -eq 0 ]
then
  echo "Backup successful created"
else
	rm $BACKUP_NAME
  echo "Backup failed" >&2
fi

# remove lock
echo "remove lock"
rm -f ${LOCKFILE}

echo "backup finished"

#! /bin/bash
 
TIMESTAMP=$(date +"%F")
BACKUP_DIR="/root/backup/$TIMESTAMP"
MYSQL_USER="root"
MYSQL=/usr/bin/mysql
MYSQL_PASSWORD="t56vg78nhk89sjsmkweoi"
MYSQLDUMP=/usr/bin/mysqldump
 
mkdir -p "$BACKUP_DIR/mysql"
 
databases=`docker exec mysqlservice_db_1 $MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)"`
 
for db in $databases; do
     docker exec $MYSQLDUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db | gzip >  "s3cmd put - s3://reconvertmysqlbackupprod/daily/DBbackup/$db.gz"
done


#!/bin/bash

# configure
USER="root"
PASS=""
DB="inventorysystem"

# change to where the script is stored
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# make log directories
mkdir -p ./migrations
mkdir -p ./logs

# dump the mysql schema
mysqldump -d -u $USER --password=$PASS --opt $DB --single-transaction --add-drop-table=FALSE | sed 's/ AUTO_INCREMENT=[0-9]*\b//' > ./logs/dbdump-$(date +%Y-%m-%d-%T).sql

# create a diff
# find will include hidden files, so only find "*.sql"
NEWDIFF=$(find ./migrations -type f \( -iname "*.sql" \) | wc -l | xargs)
echo "NEWDIFF=$NEWDIFF"
if [[ $(find ./logs -type f \( -iname "*.sql" \)| wc -l) -gt 1 ]]; then
    echo "Ceating ${NEWDIFF}.sql"
    mysqldiff -u $USER $(ls ./logs/dbdump* | awk '{print $1}' | tail -2 | tr "\\n" " ") > "./migrations/${NEWDIFF}.sql"
else
    echo "Creating base 0.sql"
    cp $(ls ./logs/dbdump*|awk '{print $1}'|tail -1) ./migrations/0.sql
    exit
fi

# don't bother saving empty files & schema logs that haven't changed
if [[ ! -s ./migrations/${NEWDIFF}.sql ]]; then
    echo "No update to the database, unlink ${NEWDIFF}.sql"
    unlink ./migrations/${NEWDIFF}.sql
    unlink $(ls ./logs/dbdump*|awk '{print $1}'|tail -1)
fi
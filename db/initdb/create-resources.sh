#!/bin/bash

cd /data/resource

for file in *.csv; do
    if [ -f "$file" ]; then
        table_name=${file%.csv}

        psql -U ${POSTGRES_USER} -c "
            CREATE TABLE IF NOT EXISTS resource.$table_name (
                id serial4 NOT NULL PRIMARY KEY,
                theographic_id varchar NULL,
                title varchar NULL,
                item_num int4 NULL,
                match_type varchar NULL,
                match_slug varchar NULL,
                text varchar NULL
            );
        "

        psql -U ${POSTGRES_USER} -c "
            COPY resource.$table_name(id, theographic_id, title, item_num, match_type, match_slug, text)
            FROM '/data/resource/$file'
            DELIMITER ','
            CSV HEADER;
        "
    fi
done
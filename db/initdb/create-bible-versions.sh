#!/bin/bash

cd /data/bible

for file in *.csv; do
    if [ -f "$file" ]; then
        table_name=${file%.csv}

        psql -U ${POSTGRES_USER} -c "
            CREATE TABLE IF NOT EXISTS bible.$table_name (
                verse_id int references public.verses(id),
                text TEXT,
                PRIMARY KEY (verse_id)
            );
        "

        psql -U ${POSTGRES_USER} -c "
            COPY bible.$table_name(verse_id, text)
            FROM '/data/bible/$file'
            DELIMITER ','
            CSV HEADER;
        "
    fi
done
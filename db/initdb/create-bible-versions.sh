#!/bin/bash

cd /data/bible

for file in *.csv; do
    if [ -f "$file" ]; then
        table_name=${file%.csv}

        psql -U ${POSTGRES_USER} -c "
            CREATE TABLE IF NOT EXISTS bible.$table_name (
                verse_id serial4 NOT NULL PRIMARY KEY,
                text varchar NULL,
                CONSTRAINT bible_${table_name}_verse_id_fkey FOREIGN KEY (verse_id) REFERENCES public.verse (id)
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
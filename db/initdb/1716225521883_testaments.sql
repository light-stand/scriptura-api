BEGIN;

-- Create table
CREATE TABLE
    testament (
        id serial PRIMARY KEY,
        uid text,
        name text,
        slug text,
        code text,
        created_at timestamp DEFAULT CURRENT_TIMESTAMP,
        updated_at timestamp DEFAULT CURRENT_TIMESTAMP
    );

-- Copy CSV
COPY testament (id, uid, name, slug, code)
FROM
    '/data/1716225521883_testaments.csv' DELIMITER ',' CSV HEADER;

COMMIT;
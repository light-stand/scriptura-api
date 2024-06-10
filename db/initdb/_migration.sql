
-- Schema
CREATE SCHEMA bible;
CREATE SCHEMA resource;

-- Role
CREATE USER anon;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO anon;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO anon;
GRANT USAGE ON SCHEMA bible TO anon;
GRANT SELECT ON ALL TABLES IN SCHEMA bible TO anon;
ALTER DEFAULT PRIVILEGES IN SCHEMA bible GRANT SELECT ON TABLES TO anon;
GRANT SELECT ON ALL TABLES IN SCHEMA resource TO anon;
ALTER DEFAULT PRIVILEGES IN SCHEMA resource GRANT SELECT ON TABLES TO anon;


-- Tables
-- Bible structure
-- Testament
CREATE TABLE
    testaments (
        id int PRIMARY KEY,
        "name" varchar,
        slug varchar,
        code varchar
    );

COPY testaments (id, name, slug, code)
FROM '/data/testaments.csv' DELIMITER ',' CSV HEADER;

-- Book division
CREATE TABLE
    book_divisions (
        id int PRIMARY KEY,
        "name" varchar,
        slug varchar,
        testament_id int references testaments(id)
    );

COPY book_divisions (id, name, slug, testament_id)
FROM '/data/book_divisions.csv' DELIMITER ',' CSV HEADER;

-- Book
CREATE TABLE
    books (
        id int PRIMARY KEY,
        division_id int references book_divisions(id),
        theographic_id varchar,
        slug varchar,
        "name" varchar,
        short_name varchar
    );

COPY books (
    id,
    division_id,
    theographic_id,
    slug,
    name,
    short_name
)
FROM '/data/books.csv' DELIMITER ',' CSV HEADER;

-- Chapter
CREATE TABLE
    chapters (
        id int PRIMARY KEY,
        book_id int references books(id),
        theographic_id varchar,
        chapter_num int
    );

COPY chapters (id, book_id, theographic_id, chapter_num)
FROM '/data/chapters.csv' DELIMITER ',' CSV HEADER;

-- Verse
CREATE TABLE
    verses (
        id int PRIMARY KEY,
        book_id int references books(id),
        chapter_id int references chapters(id),
        theographic_id varchar,
        chapter_num int,
        verse_num int,
        "year" int,
        STATUS varchar,
        text text
    );

COPY verses (
    id,
    book_id,
    chapter_id,
    theographic_id,
    chapter_num,
    verse_num,
    year,
    STATUS
)
FROM '/data/verses.csv' DELIMITER ',' CSV HEADER;

-- Encyclopedia tables
-- Event
CREATE TABLE
    events (
        id int PRIMARY KEY,
        theographic_id varchar,
        title varchar,
        start_date varchar,
        duration varchar,
        predecessor int,
        part_of int,
        notes varchar,
        "lag" varchar,
        lag_type varchar
    );

COPY events (
    id,
    theographic_id,
    title,
    start_date,
    duration,
    predecessor,
    part_of,
    notes,
    lag,
    lag_type
)
FROM '/data/events.csv' DELIMITER ',' CSV HEADER;

-- Person
CREATE TABLE
    people (
        id int PRIMARY KEY,
        theographic_id varchar,
        slug varchar,
        "name" varchar,
        surname varchar,
        display_name varchar,
        gender varchar,
        alias varchar,
        min_year int,
        max_year int,
        birth_year int,
        death_year int,
        STATUS varchar,
        is_proper_name bool,
        ambiguous bool,
        disambiguation_temp varchar,
        CONSTRAINT person_slug_key UNIQUE (slug)
    );

COPY people (
    id,
    theographic_id,
    slug,
    name,
    surname,
    display_name,
    gender,
    alias,
    min_year,
    max_year,
    birth_year,
    death_year,
    STATUS,
    is_proper_name,
    ambiguous,
    disambiguation_temp
)
FROM '/data/people.csv' DELIMITER ',' CSV HEADER;

-- Place
CREATE TABLE
    places (
        id int PRIMARY KEY,
        theographic_id varchar,
        slug varchar,
        display_title varchar,
        latitude float8,
        longitude float8,
        kjv_name varchar,
        esv_name varchar,
        feature_type varchar,
        open_bible_lat float8,
        open_bible_long float8,
        root_id int,
        "precision" varchar,
        aliases varchar,
        "comment" varchar,
        STATUS varchar,
        ambiguous bool,
        duplicate_of varchar,
        CONSTRAINT place_slug_key UNIQUE (slug)
    );

COPY places (
    id,
    theographic_id,
    slug,
    display_title,
    latitude,
    longitude,
    kjv_name,
    esv_name,
    feature_type,
    open_bible_lat,
    open_bible_long,
    root_id,
    precision,
    aliases,
    COMMENT,
    STATUS,
    ambiguous,
    duplicate_of
)
FROM '/data/places.csv' DELIMITER ',' CSV HEADER;

-- Join tables
CREATE TABLE
    events_verses (
        id int,
        event_id int references events(id),
        verse_id int references verses(id),
        primary key(id, event_id, verse_id)
    );

COPY events_verses (id, event_id, verse_id)
FROM '/data/events_verses.csv' DELIMITER ',' CSV HEADER;

--
CREATE TABLE
    people_verses (
        id int,
        person_id int references people(id),
        verse_id int references verses(id),
        primary key(id, person_id, verse_id)
    );

COPY people_verses (id, person_id, verse_id)
FROM '/data/people_verses.csv' DELIMITER ',' CSV HEADER;

--
CREATE TABLE
    places_verses (
        id int,
        place_id int references places(id),
        verse_id int references verses(id),
        primary key(id, place_id, verse_id)
    );

COPY places_verses (id, place_id, verse_id)
FROM '/data/places_verses.csv' DELIMITER ',' CSV HEADER;

-- Bible versions
CREATE TABLE
    bible_versions (
        id int PRIMARY KEY,
        "translation" varchar,
        STATUS varchar,
        "table_name" varchar
    );

COPY bible_versions (id, translation, STATUS, table_name)
FROM '/data/bible_versions.csv' DELIMITER ',' CSV HEADER;

-- Resources
CREATE TABLE
    resources (
        id int PRIMARY KEY,
        slug varchar,
        "name" varchar,
        alt varchar,
        author varchar,
        publish_year int,
        "language" varchar,
        wikipedia_slug varchar
    );

COPY resources (
    id,
    slug,
    name,
    alt,
    author,
    publish_year,
    language,
    wikipedia_slug
)
FROM '/data/resources.csv' DELIMITER ',' CSV HEADER;
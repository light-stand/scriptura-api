-- Role
CREATE USER anon;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO anon;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO anon;

-- Schema
CREATE SCHEMA bible;

CREATE SCHEMA resource;

-- Tables
-- Bible structure
-- Testament
CREATE TABLE
    testament (
        id int PRIMARY KEY,
        "name" varchar,
        slug varchar,
        code varchar
    );

COPY testament (id, name, slug, code)
FROM '/data/testament.csv' DELIMITER ',' CSV HEADER;

-- Book division
CREATE TABLE
    book_division (
        id int PRIMARY KEY,
        "name" varchar,
        slug varchar,
        testament_id int references testament(id)
    );

COPY book_division (id, name, slug, testament_id)
FROM '/data/book_division.csv' DELIMITER ',' CSV HEADER;

-- Book
CREATE TABLE
    book (
        id int PRIMARY KEY,
        division_id int references book_division(id),
        theographic_id varchar,
        slug varchar,
        "name" varchar,
        short_name varchar
    );

COPY book (
    id,
    division_id,
    theographic_id,
    slug,
    name,
    short_name
)
FROM '/data/book.csv' DELIMITER ',' CSV HEADER;

-- Chapter
CREATE TABLE
    chapter (
        id int PRIMARY KEY,
        book_id int references book(id),
        theographic_id varchar,
        chapter_num int
    );

COPY chapter (id, book_id, theographic_id, chapter_num)
FROM '/data/chapter.csv' DELIMITER ',' CSV HEADER;

-- Verse
CREATE TABLE
    verse (
        id int PRIMARY KEY,
        book_id int references book(id),
        chapter_id int references chapter(id),
        theographic_id varchar,
        chapter_num int,
        verse_num int,
        "year" int,
        STATUS varchar
    );

COPY verse (
    id,
    book_id,
    chapter_id,
    theographic_id,
    chapter_num,
    verse_num,
    year,
    STATUS
)
FROM '/data/verse.csv' DELIMITER ',' CSV HEADER;

-- Encyclopedia tables
-- Event
CREATE TABLE
    event (
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

COPY event (
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
FROM '/data/event.csv' DELIMITER ',' CSV HEADER;

-- Person
CREATE TABLE
    person (
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

COPY person (
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
FROM '/data/person.csv' DELIMITER ',' CSV HEADER;

-- Place
CREATE TABLE
    place (
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

COPY place (
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
FROM '/data/place.csv' DELIMITER ',' CSV HEADER;

-- Join tables
CREATE TABLE
    event_verse (
        id int,
        event_id int references event(id),
        verse_id int references verse(id),
        primary key(id, event_id, verse_id)
    );

COPY event_verse (id, event_id, verse_id)
FROM '/data/event_verse.csv' DELIMITER ',' CSV HEADER;

--
CREATE TABLE
    person_verse (
        id int,
        person_id int references person(id),
        verse_id int references verse(id),
        primary key(id, person_id, verse_id)
    );

COPY person_verse (id, person_id, verse_id)
FROM '/data/person_verse.csv' DELIMITER ',' CSV HEADER;

--
CREATE TABLE
    place_verse (
        id int,
        place_id int references place(id),
        verse_id int references verse(id),
        primary key(id, place_id, verse_id)
    );

COPY place_verse (id, place_id, verse_id)
FROM '/data/place_verse.csv' DELIMITER ',' CSV HEADER;

-- Bible versions
CREATE TABLE
    bible_version (
        id int PRIMARY KEY,
        "translation" varchar,
        STATUS varchar,
        "table_name" varchar
    );

COPY bible_version (id, translation, STATUS, table_name)
FROM '/data/bible_version.csv' DELIMITER ',' CSV HEADER;

-- Resources
CREATE TABLE
    resource (
        id int PRIMARY KEY,
        slug varchar,
        "name" varchar,
        alt varchar,
        author varchar,
        publish_year int,
        "language" varchar,
        wikipedia_slug varchar
    );

COPY resource (
    id,
    slug,
    name,
    alt,
    author,
    publish_year,
    language,
    wikipedia_slug
)
FROM '/data/resource.csv' DELIMITER ',' CSV HEADER;
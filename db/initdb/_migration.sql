-- Role
CREATE USER anon;

GRANT USAGE ON SCHEMA public TO anon;

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO anon;

GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO anon;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO anon;

-- Schema
CREATE SCHEMA bible;

CREATE SCHEMA resource;

-- Tables
-- Bible structure
-- Testament
CREATE TABLE
    public.testament (
        id serial4 NOT NULL PRIMARY KEY,
        "name" varchar NULL,
        slug varchar NULL,
        code varchar NULL
    );

COPY public.testament (id, name, slug, code)
FROM '/data/testament.csv' DELIMITER ',' CSV HEADER;

-- Book division
CREATE TABLE
    public.book_division (
        id serial4 NOT NULL PRIMARY KEY,
        "name" varchar NULL,
        slug varchar NULL,
        testament_id int4 NULL,
        CONSTRAINT book_divisions_testament_id_fkey FOREIGN KEY (testament_id) REFERENCES public.testament (id)
    );

COPY public.book_division (id, name, slug, testament_id)
FROM '/data/book_division.csv' DELIMITER ',' CSV HEADER;

-- Book
CREATE TABLE
    public.book (
        id serial4 NOT NULL PRIMARY KEY,
        division_id int4 NULL,
        theographic_id varchar NULL,
        slug varchar NULL,
        "name" varchar NULL,
        short_name varchar NULL,
        CONSTRAINT books_division_id_fkey FOREIGN KEY (division_id) REFERENCES public.book_division (id)
    );

COPY public.book (
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
    public.chapter (
        id serial4 NOT NULL PRIMARY KEY,
        book_id int4 NULL,
        theographic_id varchar NULL,
        chapter_num int4 NULL,
        CONSTRAINT chapters_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book (id)
    );

COPY public.chapter (id, book_id, theographic_id, chapter_num)
FROM '/data/chapter.csv' DELIMITER ',' CSV HEADER;

-- Verse
CREATE TABLE
    public.verse (
        id serial4 NOT NULL PRIMARY KEY,
        book_id int4 NULL,
        chapter_id int4 NULL,
        theographic_id varchar NULL,
        chapter_num int4 NULL,
        verse_num int4 NULL,
        "year" int4 NULL,
        STATUS varchar NULL,
        CONSTRAINT verses_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book (id),
        CONSTRAINT verses_chapter_id_fkey FOREIGN KEY (chapter_id) REFERENCES public.chapter (id)
    );

COPY public.verse (
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
    public.event (
        id serial4 NOT NULL PRIMARY KEY,
        theographic_id varchar NULL,
        title varchar NULL,
        start_date varchar NULL,
        duration varchar NULL,
        predecessor int4 NULL,
        part_of int4 NULL,
        notes varchar NULL,
        "lag" varchar NULL,
        lag_type varchar NULL
    );

COPY public.event (
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
    public.person (
        id serial4 NOT NULL PRIMARY KEY,
        theographic_id varchar NULL,
        slug varchar NULL,
        "name" varchar NULL,
        surname varchar NULL,
        display_name varchar NULL,
        gender varchar NULL,
        alias varchar NULL,
        min_year int4 NULL,
        max_year int4 NULL,
        birth_year int4 NULL,
        death_year int4 NULL,
        STATUS varchar NULL,
        is_proper_name bool NULL,
        ambiguous bool NULL,
        disambiguation_temp varchar NULL,
        CONSTRAINT person_slug_key UNIQUE (slug)
    );

COPY public.person (
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
    public.place (
        id serial4 NOT NULL PRIMARY KEY,
        theographic_id varchar NULL,
        slug varchar NULL,
        display_title varchar NULL,
        latitude float8 NULL,
        longitude float8 NULL,
        kjv_name varchar NULL,
        esv_name varchar NULL,
        feature_type varchar NULL,
        open_bible_lat float8 NULL,
        open_bible_long float8 NULL,
        root_id int4 NULL,
        "precision" varchar NULL,
        aliases varchar NULL,
        "comment" varchar NULL,
        STATUS varchar NULL,
        ambiguous bool NULL,
        duplicate_of varchar NULL,
        CONSTRAINT place_slug_key UNIQUE (slug)
    );

COPY public.place (
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
    public.event_verse (
        id serial4 NOT NULL PRIMARY KEY,
        event_id int4 NULL,
        verse_id int4 NULL,
        CONSTRAINT event_verses_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.event (id),
        CONSTRAINT event_verses_verse_id_fkey FOREIGN KEY (verse_id) REFERENCES public.verse (id)
    );

COPY public.event_verse (id, event_id, verse_id)
FROM '/data/event_verse.csv' DELIMITER ',' CSV HEADER;

--
CREATE TABLE
    public.person_verse (
        id serial4 NOT NULL PRIMARY KEY,
        person_id int4 NULL,
        verse_id int4 NULL,
        CONSTRAINT person_verses_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person (id),
        CONSTRAINT person_verses_verse_id_fkey FOREIGN KEY (verse_id) REFERENCES public.verse (id)
    );

COPY public.person_verse (id, person_id, verse_id)
FROM '/data/person_verse.csv' DELIMITER ',' CSV HEADER;

--
CREATE TABLE
    public.place_verse (
        id serial4 NOT NULL PRIMARY KEY,
        place_id int4 NULL,
        verse_id int4 NULL,
        CONSTRAINT place_verses_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.place (id),
        CONSTRAINT place_verses_verse_id_fkey FOREIGN KEY (verse_id) REFERENCES public.verse (id)
    );

COPY public.place_verse (id, place_id, verse_id)
FROM '/data/place_verse.csv' DELIMITER ',' CSV HEADER;

-- Bible versions
CREATE TABLE
    public.bible_version (
        id serial4 NOT NULL PRIMARY KEY,
        "translation" varchar NULL,
        STATUS varchar NULL,
        "table_name" varchar NULL
    );

COPY public.bible_version (id, translation, STATUS, table_name)
FROM '/data/bible_version.csv' DELIMITER ',' CSV HEADER;

-- Resources
CREATE TABLE
    public.resource (
        id serial4 NOT NULL PRIMARY KEY,
        slug varchar NULL,
        "name" varchar NULL,
        alt varchar NULL,
        author varchar NULL,
        publish_year int4 NULL,
        "language" varchar NULL,
        wikipedia_slug varchar NULL
    );

COPY public.resource (
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
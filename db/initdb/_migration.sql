
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

CREATE INDEX ON testaments("name");
CREATE INDEX ON testaments(slug);
CREATE INDEX ON testaments(code);

CREATE VIEW testaments_view AS
SELECT id, name, slug, code
FROM testaments;

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

CREATE INDEX ON book_divisions("name");
CREATE INDEX ON book_divisions(slug);
CREATE INDEX ON book_divisions(testament_id);

CREATE VIEW book_divisions_view AS
SELECT 
    id, 
    name, 
    slug, 
    testament_id as testamentId
FROM book_divisions;

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

CREATE INDEX ON books(division_id);
CREATE INDEX ON books("name");
CREATE INDEX ON books(slug);
CREATE INDEX ON books(short_name);

CREATE VIEW books_view AS
SELECT 
    id, 
    division_id as divisionId,
    slug, 
    name, 
    short_name as shortName
FROM books;


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

CREATE INDEX ON chapters(book_id);
CREATE INDEX ON chapters(chapter_num);

CREATE VIEW chapters_view AS
SELECT 
    id, 
    book_id as bookId, 
    chapter_num as chapterNum
FROM chapters;

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
        "status" varchar,
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
    "status"
)
FROM '/data/verses.csv' DELIMITER ',' CSV HEADER;

CREATE INDEX ON verses(book_id);
CREATE INDEX ON verses(chapter_id);
CREATE INDEX ON verses(verse_num);

CREATE VIEW verses_view AS
SELECT 
    id, 
    book_id as bookId, 
    chapter_id as chapterId, 
    chapter_num as chapterNum, 
    verse_num as verseNum, 
    "year", 
    "status", 
    text
FROM verses;

-- Encyclopedia tables
-- Event
CREATE TABLE
    events (
        id int PRIMARY KEY,
        theographic_id varchar,
        title varchar,
        start_date varchar,
        duration varchar,
        predecessor int references events(id),
        part_of int references events(id),
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

CREATE INDEX ON events(title);
CREATE INDEX ON events(start_date);
CREATE INDEX ON events(predecessor);
CREATE INDEX ON events(part_of);

CREATE VIEW events_view AS
SELECT 
    id, 
    title, 
    start_date as startDate, 
    duration, 
    predecessor, 
    part_of as partOf, 
    notes, 
    lag, 
    lag_type as lagType
FROM events;


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
        "status" varchar,
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
    "status",
    is_proper_name,
    ambiguous,
    disambiguation_temp
)
FROM '/data/people.csv' DELIMITER ',' CSV HEADER;

CREATE INDEX ON people("name");
CREATE INDEX ON people(surname);
CREATE INDEX ON people(slug);
CREATE INDEX ON people(display_name);

CREATE VIEW people_view AS
SELECT 
    id, 
    slug, 
    name, 
    surname, 
    display_name as displayName,
    gender,
    alias,
    min_year as minYear,
    max_year as maxYear,
    birth_year as birthYear,
    death_year as deathYear,
    "status"
FROM people;

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
        root_id int references places(id),
        "precision" varchar,
        aliases varchar,
        "comment" varchar,
        "status" varchar,
        ambiguous bool,
        duplicate_of int references places(id),
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
    comment,
    "status",
    ambiguous,
    duplicate_of
)
FROM '/data/places.csv' DELIMITER ',' CSV HEADER;

CREATE INDEX ON places(slug);
CREATE INDEX ON places(display_title);
CREATE INDEX ON places(latitude);
CREATE INDEX ON places(longitude);
CREATE INDEX ON places(kjv_name);
CREATE INDEX ON places(esv_name);
CREATE INDEX ON places(feature_type);

CREATE VIEW places_view AS
SELECT 
    id, 
    slug, 
    display_title as displayTitle, 
    latitude, 
    longitude, 
    kjv_name as kjvName, 
    esv_name as esvName, 
    feature_type as featureType, 
    open_bible_lat as openBibleLat, 
    open_bible_long as openBibleLong, 
    root_id as rootId, 
    precision, 
    aliases, 
    "comment", 
    "status", 
    ambiguous, 
    duplicate_of as duplicateOf
FROM places;


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

CREATE INDEX ON events_verses(event_id, verse_id);

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

CREATE INDEX ON people_verses(person_id, verse_id);

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

CREATE INDEX ON places_verses(place_id, verse_id);

-- Bible versions
CREATE TABLE
    bible_versions (
        id int PRIMARY KEY,
        "translation" varchar,
        "status" varchar,
        "table_name" varchar
    );

COPY bible_versions (id, translation, "status", table_name)
FROM '/data/bible_versions.csv' DELIMITER ',' CSV HEADER;

CREATE INDEX ON bible_versions("translation");
CREATE INDEX ON bible_versions("status");
CREATE INDEX ON bible_versions(table_name);

CREATE VIEW bible_versions_view AS
SELECT 
    id, 
    translation, 
    "status", 
    table_name as tableName
FROM bible_versions;

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

CREATE INDEX ON resources(slug);
CREATE INDEX ON resources("name");
CREATE INDEX ON resources("alt");
CREATE INDEX ON resources(author);
CREATE INDEX ON resources(publish_year);
CREATE INDEX ON resources("language");
CREATE INDEX ON resources(wikipedia_slug);

CREATE VIEW resources_view AS
SELECT 
    id, 
    slug, 
    name, 
    alt, 
    author, 
    publish_year as publishYear, 
    "language", 
    wikipedia_slug as wikipediaSlug
FROM resources;
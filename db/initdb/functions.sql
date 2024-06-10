CREATE OR REPLACE FUNCTION bible(version TEXT default 'en_kj')
RETURNS SETOF public.verses AS $$
BEGIN
    RETURN QUERY EXECUTE format('
        SELECT 
        v.id, 
        v.book_id, 
        v.chapter_id, 
        v.theographic_id, 
        v.chapter_num, 
        v.verse_num, 
        v.year, 
        v.status, 
        b.text as text
        FROM public.verses v
        JOIN bible.%I b ON v.id = b.verse_id', version);
END;
$$ LANGUAGE plpgsql;
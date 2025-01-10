CREATE TYPE myfilm AS (
    film TEXT,
    votes INTEGER,
    rating FLOAT,
    film_id TEXT
);

CREATE TYPE quality_class AS enum('star','good','average','bad')

-- DDL for actors table
CREATE TABLE actors(
films myfilm[],
quality quality_class,
is_active BOOLEAN
);
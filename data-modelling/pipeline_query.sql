-- cumulative table generation query per year
insert into actors
WITH actors_film_by_year AS(
SELECT
      actor,
      actorid,
      film,
      year,
      votes,
      rating,
      filmid
FROM actor_films WHERE year=1970
),average_rating_by_actor AS (
SELECT 
      actorid,
      avg(rating) AS avg_rating
FROM actors_film_by_year
GROUP BY actorid
),quality_class_mapping AS (
    SELECT
        actorid,
        CASE
            WHEN avg_rating > 8 THEN 'star'
            WHEN avg_rating > 7 THEN 'good'
            WHEN avg_rating > 6 THEN 'average'
            ELSE 'bad'
        END AS quality_class
    FROM average_rating_by_actor
), are_active AS (
SELECT
      actorid,
      CASE WHEN year IS NOT NULL THEN  true 
           ELSE false 
      END AS is_active
FROM actors_film_by_year
)
--insert into actors
SELECT --actor as actor_name,
       --actorid as actor_id,
       ARRAY[ROW(
       film,
       votes,
       rating,
       filmid)::myfilm] AS films,
       quality_class::quality_class AS quality,
       --year,
       is_active AS active
FROM actors_film_by_year afby full OUTER JOIN average_rating_by_actor arba
ON afby.actorid=arba.actorid full OUTER JOIN quality_class_mapping qcm
ON qcm.actorid=arba.actorid full OUTER JOIN are_active act ON arba.actorid=act.actorid ;

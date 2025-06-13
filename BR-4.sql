select * from fact_passenger_summary;

WITH city_passenger_counts AS (
    SELECT 
        city_id,
        SUM(new_passengers) AS total_new_passengers
    FROM fact_passenger_summary
    GROUP BY city_id
),
ranked_cities AS (
    SELECT 
        c.city_id,
        c.total_new_passengers,
        RANK() OVER (ORDER BY c.total_new_passengers DESC) AS rank_desc,
        RANK() OVER (ORDER BY c.total_new_passengers ASC) AS rank_asc
    FROM city_passenger_counts c
),
classified_cities AS (
    SELECT 
        rc.city_id,
        rc.total_new_passengers,
        CASE 
            WHEN rc.rank_desc <= 3 THEN 'Top 3'
            WHEN rc.rank_asc <= 3 THEN 'Bottom 3'
            ELSE NULL
        END AS city_category
    FROM ranked_cities rc
    WHERE rc.rank_desc <= 3 OR rc.rank_asc <= 3
)
SELECT 
    d.city_name,
    cc.total_new_passengers,
    cc.city_category
FROM classified_cities cc
JOIN dim_city d ON cc.city_id = d.city_id;


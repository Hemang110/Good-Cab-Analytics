select * from dim_repeat_trip_distribution;


WITH total_repeat_passengers AS (
    SELECT 
        city_id,
        SUM(repeat_passenger_count) AS total_repeat_passengers
    FROM dim_repeat_trip_distribution
    GROUP BY city_id
),
trip_distribution AS (
    SELECT 
        d.city_id,
        d.trip_count,
        d.repeat_passenger_count,
        t.total_repeat_passengers,
        ROUND(100.0 * d.repeat_passenger_count / t.total_repeat_passengers, 2) AS percentage
    FROM dim_repeat_trip_distribution d
    JOIN total_repeat_passengers t
        ON d.city_id = t.city_id
   
),
pivoted AS (
    SELECT 
        city_id,
        MAX(CASE WHEN trip_count = '2-Trips' THEN percentage END) AS `2-Trips`,
        MAX(CASE WHEN trip_count = '3-Trips' THEN percentage END) AS `3-Trips`,
        MAX(CASE WHEN trip_count = '4-Trips' THEN percentage END) AS `4-Trips`,
        MAX(CASE WHEN trip_count = '5-Trips' THEN percentage END) AS `5-Trips`,
        MAX(CASE WHEN trip_count = '6-Trips' THEN percentage END) AS `6-Trips`,
        MAX(CASE WHEN trip_count = '7-Trips' THEN percentage END) AS `7-Trips`,
        MAX(CASE WHEN trip_count = '8-Trips' THEN percentage END) AS `8-Trips`,
        MAX(CASE WHEN trip_count = '9-Trips' THEN percentage END) AS `9-Trips`,
        MAX(CASE WHEN trip_count = '10-Trips' THEN percentage END) AS `10-Trips`
    FROM trip_distribution
    GROUP BY city_id
)
SELECT 
    c.city_name,
    p.*
FROM pivoted p
JOIN dim_city c ON p.city_id = c.city_id;

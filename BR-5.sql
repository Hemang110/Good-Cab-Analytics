select * from fact_trips;

WITH monthly_revenue AS (
    SELECT 
        city_id,
        DATE_FORMAT(date, '%Y-%m') AS month,
        SUM(fare_amount) AS revenue
    FROM fact_trips
    GROUP BY city_id, DATE_FORMAT(date, '%Y-%m')
),
ranked_monthly_revenue AS (
    SELECT 
        m.city_id,
        m.month,
        m.revenue,
        RANK() OVER (PARTITION BY m.city_id ORDER BY m.revenue DESC) AS revenue_rank
    FROM monthly_revenue m
)
SELECT 
    city_id,
    month AS highest_revenue_month,
    revenue
FROM ranked_monthly_revenue
WHERE revenue_rank = 1
ORDER BY city_id;






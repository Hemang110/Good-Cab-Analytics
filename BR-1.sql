#BUSINESS REQUEST-1
/*city_name, total_trips,avg_fare_per_km,avg_fare_per_trip,%_contribution_of_total_trips*/

use trips_db;

select * from dim_city;

select * from fact_trips;

select city_name, 
    count(trip_id) as total_count,
    round(sum(fare_amount)/sum(distance_travelled_km),1) as avg_fare_per_km,
    round(sum(fare_amount)/count(trip_id),1) as avg_fare_per_trip,
    concat(round(count(trip_id)/(select count(trip_id) from fact_trips)*100,2),'%') as '%_contribution'
	from fact_trips f 
	join dim_city d
    on f.city_id = d.city_id
    group by f.city_id;
SELECT
	CAST(lpep_pickup_datetime AS DATE),
	trip_distance
FROM
	green_taxi_trips
ORDER BY trip_distance DESC;
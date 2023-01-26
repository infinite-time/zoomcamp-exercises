SELECT	
	*
FROM 
	green_taxi_trips
WHERE
	CAST(lpep_pickup_datetime AS DATE) = '2019-01-15' AND
	CAST(lpep_dropoff_datetime AS DATE) = '2019-01-15';
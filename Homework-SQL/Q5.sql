SELECT
	COUNT(1)
FROM
	green_taxi_trips
WHERE
	CAST(lpep_pickup_datetime AS DATE) = '2019-01-01' AND
	passenger_count = 2;

SELECT
	COUNT(1)
FROM
	green_taxi_trips
WHERE
	CAST(lpep_pickup_datetime AS DATE) = '2019-01-01' AND
	passenger_count = 3;
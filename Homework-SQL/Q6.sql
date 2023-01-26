SELECT 
	z."Zone", g."DOLocationID", g.tip_amount
FROM
	green_taxi_trips g JOIN zones z
ON
	g."PULocationID" = z."LocationID" AND
	z."Zone" = 'Astoria'
ORDER BY
	g.tip_amount DESC;

SELECT
	*
FROM
	zones
WHERE
	zones."LocationID" = 146; /*146 is the value you get from the first query above*/
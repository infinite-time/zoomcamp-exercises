-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `taxi_rides_ny.fhv_tripdata_2019`
OPTIONS (
  format = 'CSV',
  uris = ['gs://fhv-taxi/fhv_tripdata_2019-*.csv.gz']
);

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE taxi_rides_ny.fhv_tripdata_2019_non_partitoned AS
SELECT * FROM taxi_rides_ny.fhv_tripdata_2019;

-- Count the distinct number of affiliated_base_number from external table
SELECT DISTINCT COUNT(Affiliated_base_number) FROM `ny-rides-vinay.taxi_rides_ny.fhv_tripdata_2019`;

-- Count the distinct number of affiliated_base_number from Big Query table
SELECT DISTINCT COUNT(Affiliated_base_number) FROM `ny-rides-vinay.taxi_rides_ny.fhv_tripdata_2019_non_partitoned`;

-- Count the records that have both a blank (null) PUlocationID and DOlocationID
SELECT COUNT(*) FROM `ny-rides-vinay.taxi_rides_ny.fhv_tripdata_2019_non_partitoned` WHERE PULocationID IS NULL AND DOLocationID IS NULL;

-- Creating a partition and cluster table
CREATE OR REPLACE TABLE taxi-rides-ny.taxi_rides_ny.fhv_tripdata_2019_partitoned
PARTITION BY DATE(pickup_datetime) 
CLUSTER BY Affiliated_base_number AS
SELECT * FROM taxi_rides_ny.fhv_tripdata_2019;

-- Count the distinct number of affiliated_base_number from external table
SELECT DISTINCT COUNT(Affiliated_base_number) 
FROM `ny-rides-vinay.taxi_rides_ny.fhv_tripdata_2019` 
WHERE pickup_datetime >= '2019-03-01' AND dropOff_datetime <= '2019-03-31';

-- Count the distinct number of affiliated_base_number from non_paritioned table
SELECT DISTINCT COUNT(Affiliated_base_number) 
FROM `ny-rides-vinay.taxi_rides_ny.fhv_tripdata_2019_non_partitoned` 
WHERE pickup_datetime >= '2019-03-01' AND dropOff_datetime <= '2019-03-31';

-- Count the distinct number of affiliated_base_number from paritioned table
SELECT DISTINCT COUNT(Affiliated_base_number) 
FROM `ny-rides-vinay.taxi_rides_ny.fhv_tripdata_2019_partitoned` 
WHERE pickup_datetime >= '2019-03-01' AND dropOff_datetime <= '2019-03-31';
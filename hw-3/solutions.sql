SELECT COUNT(*)
FROM `dtc-de-course-339303.nyc_taxi.fhv_tripdata`;


SELECT COUNT(DISTINCT (dispatching_base_num))
FROM `dtc-de-course-339303.nyc_taxi.fhv_tripdata`;


CREATE OR REPLACE TABLE dtc-de-course-339303.nyc_taxi.fhv_tripdata_partitioned
PARTITION BY DATE(dropoff_datetime)
CLUSTER BY dispatching_base_num AS
SELECT * FROM dtc-de-course-339303.nyc_taxi.fhv_tripdata;


SELECT COUNT(*) FROM `dtc-de-course-339303.nyc_taxi.fhv_tripdata_partitioned`
WHERE DATE(dropoff_datetime) BETWEEN '2019-01-01' AND '2019-03-31'
AND dispatching_base_num IN ('B00987', 'B02060', 'B02279');
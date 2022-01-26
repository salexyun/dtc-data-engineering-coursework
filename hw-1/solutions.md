## Quesstion 1: gcloud version
```
Google Cloud SDK 369.0.0
bq 2.0.72
core 2022.01.14
gsutil 5.6
```

## Question 2: terraform apply
```
var.project
  Your GCP Project ID

  Enter a value: dtc-de-course-339303


Terraform used the selected providers to generate the following execution plan. Resource
actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_bigquery_dataset.dataset will be created
  + resource "google_bigquery_dataset" "dataset" {
      + creation_time              = (known after apply)
      + dataset_id                 = "trips_data_all"
      + delete_contents_on_destroy = false
      + etag                       = (known after apply)
      + id                         = (known after apply)
      + last_modified_time         = (known after apply)
      + location                   = "northamerica-northeast1"
      + project                    = "dtc-de-course-339303"
      + self_link                  = (known after apply)

      + access {
          + domain         = (known after apply)
          + group_by_email = (known after apply)
          + role           = (known after apply)
          + special_group  = (known after apply)
          + user_by_email  = (known after apply)

          + view {
              + dataset_id = (known after apply)
              + project_id = (known after apply)
              + table_id   = (known after apply)
            }
        }
    }

  # google_storage_bucket.data-lake-bucket will be created
  + resource "google_storage_bucket" "data-lake-bucket" {
      + force_destroy               = true
      + id                          = (known after apply)
      + location                    = "NORTHAMERICA-NORTHEAST1"
      + name                        = "dtc_data_lake_dtc-de-course-339303"
      + project                     = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + uniform_bucket_level_access = true
      + url                         = (known after apply)

      + lifecycle_rule {
          + action {
              + type = "Delete"
            }

          + condition {
              + age                   = 30
              + matches_storage_class = []
              + with_state            = (known after apply)
            }
        }

      + versioning {
          + enabled = true
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_bigquery_dataset.dataset: Creating...
google_storage_bucket.data-lake-bucket: Creating...
google_storage_bucket.data-lake-bucket: Creation complete after 1s [id=dtc_data_lake_dtc-de-course-339303]
google_bigquery_dataset.dataset: Creation complete after 2s [id=projects/dtc-de-course-339303/datasets/trips_data_all]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

## Question 3:Count records
How many taxi trips were there on January 15?
* 53024
```
SELECT
  CAST(tpep_pickup_datetime AS DATE) as "day",
  COUNT(1)
FROM yellow_taxi_trip
GROUP BY 1
HAVING CAST(tpep_pickup_datetime AS DATE)='2021-01-15';
```

## Question 4: Largest tip for each day
* 2021-01-20
```
SELECT
  CAST(tpep_dropoff_datetime AS DATE) AS "day",
  MAX(tip_amount) as "tip"
FROM yellow_taxi_trip
GROUP BY 1
ORDER BY "tip" DESC
LIMIT 1;
```

## Question 5: Most popular destination
* Upper East Side North
```
SELECT
  zpu."Zone" as "pickup_zone",
  zdo."Zone" as "dropoff_zone",
  COUNT(1) as "count"
FROM
  yellow_taxi_trip t,
  taxi_zone_lookup zpu,
  taxi_zone_lookup zdo
WHERE
  t."PULocationID" = zpu."LocationID" AND
  t."DOLocationID" = zdo."LocationID"
GROUP BY 1, 2
HAVING zpu."Zone"='Central Park'
ORDER BY "count" DESC
LIMIT 1;
```
## Question 6: Most expensive route
* Alphabet City / Unknown
```
SELECT
  zpu."Zone" as "pickup_zone",
  zdo."Zone" as "dropoff_zone",
  SUM(total_amount) as "earnings",
  COUNT(1) as "count",
  SUM(total_amount)/COUNT(1) as "avg_price"
FROM
  yellow_taxi_trip t,
  taxi_zone_lookup zpu,
  taxi_zone_lookup zdo
WHERE
  t."PULocationID" = zpu."LocationID" AND
  t."DOLocationID" = zdo."LocationID"
GROUP BY 1, 2
ORDER BY "avg_price" DESC
LIMIT 1;
```
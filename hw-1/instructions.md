## Create a network to run Postgres and pgAdmin together
```docker network create pg-network```

## Run Postgres with Docker
```
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="nyc_taxi" \
  -v $(pwd)/nyc_taxi_data_postgres:/var/lib/postgresql/data \
  -p 5432:5432 \
  --network=pg-network \
  --name pg-database \
  postgres:13
```
## Connect to Postgres via pgcli
```pgcli -h localhost -p 5432 -u root -d nyc_taxi```

## Run pgAdmin
```
docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  --network=pg-network \
  --name pgadmin \
  dpage/pgadmin4
```

# Build the image
```docker build -t nyc_taxi_ingest:v001 .```

# Run the script with Docker
## Trip data
```
URL="https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2021-01.csv"

docker run -it \
  --network=pg-network \
  nyc_taxi_ingest:v001 \
    --user=root \
    --password=root \
    --host=pg-database \
    --port=5432 \
    --db=nyc_taxi \
    --table_name=yellow_taxi_trip \
    --url=${URL}
```

## Lookup data
```
URL="https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv"

docker run -it \
  --network=pg-network \
  nyc_taxi_ingest:v001 \
    --user=root \
    --password=root \
    --host=pg-database \
    --port=5432 \
    --db=nyc_taxi \
    --table_name=taxi_zone_lookup \
    --url=${URL}
```
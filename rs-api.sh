set -e
cd ~/pipeline/vfb-data-ingest-api
make docker-build
cd ~/pipeline/vfb-data-ingest-config
docker-compose stop vfb-data-ingest-api
docker-compose rm -f vfb-data-ingest-api
docker-compose create vfb-data-ingest-api
docker-compose start vfb-data-ingest-api
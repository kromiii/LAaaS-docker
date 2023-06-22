#!/bin/bash

path_to_log=$1
lms_domain=$2

if [ $# != 2 ] ; then
  echo "Usage: run.sh <path_to_log> <lms_domain>"
  exit 1
fi

if [ -f "$path_to_log" ] ; then
  cat "$path_to_log" | \
    docker compose run -T -e LMS_DOMAIN=${lms_domain} log-processor | \
    docker exec -i chibichilo-xapi sh -c "cat - > /app/videojs.csv; npm start"
  cat "$path_to_log" | \
    docker compose run -T -e LMS_DOMAIN=${lms_domain} log-processor | \
    docker exec -i chibichilo-caliper sh -c \
      "cat | python3 log_processor_for_caliper.py; php app/run.php /videojs.csv"
fi

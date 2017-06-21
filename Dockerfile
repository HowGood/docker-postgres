# howgood/postgres:9.4-alpine

FROM mdillon/postgis:9.4-alpine

# Make sure the postgis init runs first
RUN cd /docker-entrypoint-initdb.d \
    && mv postgis.sh 00-postgis.sh

COPY initdb-howgood.sh /docker-entrypoint-initdb.d/10-howgood.sh

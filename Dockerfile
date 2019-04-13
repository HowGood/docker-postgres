# howgood/postgres:11-alpine

FROM mdillon/postgis:11-alpine

# Make sure the postgis init runs first
RUN cd /docker-entrypoint-initdb.d \
    && mv postgis.sh 00-postgis.sh

COPY initdb-howgood.sh /docker-entrypoint-initdb.d/10-howgood.sh
RUN chmod -x /docker-entrypoint-initdb.d/10-howgood.sh

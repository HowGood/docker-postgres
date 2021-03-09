#!/bin/bash

set -e


# Install a custom config
cat >> "${PGDATA}/postgresql.conf" <<EOS

##
# howgood/postgres | test db
##

listen_addresses = '*'
exit_on_error = off
restart_after_crash = on
external_pid_file = '/tmp/postgresql.pid'

client_min_messages = log

# unsafe - used for testing
fsync = off
synchronous_commit = off
full_page_writes = off

EOS

# Install extensions
for DB in template_postgis "$POSTGRES_DB" template1; do
  echo "Creating extensions for ${DB}..."
  "${psql[@]}" --echo-all --dbname="$DB" <<-'EOSQL'

  CREATE EXTENSION IF NOT EXISTS postgis;
  CREATE EXTENSION IF NOT EXISTS postgis_topology;
  CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
  CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;

  CREATE EXTENSION IF NOT EXISTS hstore;
  CREATE EXTENSION IF NOT EXISTS pg_trgm;
  CREATE EXTENSION IF NOT EXISTS citext;

EOSQL
done

#!/bin/bash

set -e


# Install our custom config
cat >> "$PGDATA/postgresql.conf" <<EOS

# - howgood/postgres - #
# - : custom config  - #

listen_addresses = '*'
exit_on_error = off
restart_after_crash = on
external_pid_file = '/tmp/postgresql.pid'

EOS

# If extensions are listed, create them
echo
for extension in $POSTGRES_EXTENSIONS; do
  psql \
    --echo-queries \
    --set ON_ERROR_STOP=1 \
    --username "$POSTGRES_USER" \
    --command \
      "CREATE EXTENSION $extension ;"
  echo "- Created extension $extension"
done
echo

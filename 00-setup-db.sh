#!/bin/bash

set -e


# Install our custom config
cat >> "$PGDATA/postgresql.conf" <<EOS

# - howgood/postgres - #
# - : custom config  - #

# LOGGING
log_min_error_statement = fatal

# CONNECTION
listen_addresses = '*'

# REPLICATION
wal_level = logical            # use logical decoding with the write-ahead log
max_wal_senders = 4            # max number of separate processes for processing WAL changes
max_replication_slots = 4      # max number of replication slots to be created for streaming WAL changes
wal_keep_segments = 0          # in logfile segments, 16MB each; 0 disables
wal_sender_timeout = 60s       # in milliseconds; 0 disables

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

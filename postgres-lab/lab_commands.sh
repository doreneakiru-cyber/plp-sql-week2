#!/bin/bash

# --- Step 1: Take and Verify a Logical Backup ---
mkdir -p ~/backups
pg_dump -Fc -f ~/backups/bootcamp.dump bootcamp
pg_restore --list ~/backups/bootcamp.dump | head
createdb bootcamp_check && pg_restore -d bootcamp_check ~/backups/bootcamp.dump

# --- Step 2: Enable WAL Archiving & Base Backup ---
# In postgresql.conf:
# wal_level = replica
# archive_mode = on
# archive_command = 'cp %p /home/$USER/backups/wal/%f'
mkdir -p ~/backups/wal
sudo systemctl restart postgresql
pg_basebackup -D ~/backups/base -Ft -z -Xs -P

# --- Step 3: Simulate Disaster and Point-in-Time Recovery ---
# SELECT now();   -- Record time before deletion
# DELETE FROM students;

# Recovery settings in postgresql.conf:
# restore_command = 'cp ~/backups/wal/%f %p'
# recovery_target_time = '2025-06-01 10:00:00'

# --- Step 4: Set Up a Streaming Standby ---
# On primary:
# CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'reppass';
# In pg_hba.conf: host replication replicator 127.0.0.1/32 md5

# Build the standby replica:
pg_basebackup -h 127.0.0.1 -U replicator -D ~/standby -R -P

# --- Step 5: Check Replication Status ---
# SELECT application_name, state, pg_wal_lsn_diff(sent_lsn, replay_lsn) AS lag_bytes FROM pg_stat_replication;

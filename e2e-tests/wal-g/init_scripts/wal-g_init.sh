#!/bin/bash
echo "Executing initialization shell script for wal-g"
USER=${GREENPLUM_USER} gpconfig -c archive_command -v "wal-g seg wal-push %p --content-id=%c --config /tmp/wal-g.yaml"
USER=${GREENPLUM_USER} gpconfig -c archive_timeout -v 600 --skipvalidation
USER=${GREENPLUM_USER} gpstop -u
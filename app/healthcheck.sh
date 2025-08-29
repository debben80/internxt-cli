#!/bin/sh
set -e

if [ "$HEALTHCHECK_ENABLED" -eq 1 ]; then
    exec internxt webdav status
else
    exit 0
fi
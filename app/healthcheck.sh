#!/bin/sh
set -e

if [ -f "/app/webdav" ]; then
    internxt webdav status || kill 1
else
    exit 0
fi

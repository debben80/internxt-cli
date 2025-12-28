#!/bin/sh
set -e
. /app/functions.sh
spath="$(readlink -f "$0")"
if [ "$(whoami)" = "root" ]; then
  exec su-exec appuser "$spath" "$@"
fi

WEBDAV_HOST=${WEBDAV_HOST:-127.0.0.1}
WEBDAV_PROTO=${WEBDAV_PROTO:-https}
WEBDAV_PORT=${WEBDAV_PORT:-3005}
WEBDAV_LOGS=${WEBDAV_LOGS:-error}

log "WebDAV server mode..."
internxt_webdav
internxt_watch

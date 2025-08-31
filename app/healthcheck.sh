#!/bin/sh
set -e
spath="$(readlink -f "$0")"
if [ "$(whoami)" = "root" ]; then
  exec su-exec appuser "$spath" "$@"
fi

internxt whoami | grep -q "$INTERNXT_EMAIL" && echo "logged with $INTERNXT_EMAIL" || exit 1
if [ -f "/app/webdav" ]; then
    internxt webdav status | grep -q "online" && echo "WebDAV server online" || exit 1
fi

exit 0

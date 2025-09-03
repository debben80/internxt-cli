#!/bin/sh
set -e

# Privilege Dropping
spath="$(readlink -f "$0")"
if [ "$(whoami)" = "root" ]; then
  exec su-exec appuser "$spath" "$@"
fi

# Internxt Login Check
internxt_whoami=$(internxt whoami --json | jq -r '.login.user.username')
if [ "$internxt_whoami" = "$INTERNXT_EMAIL" ]; then
  echo "logged with $INTERNXT_EMAIL"
else
  exit 1
fi

# WebDAV Server Status Check
if [ -f "/app/webdav.mode" ]; then
  internxt_webdav_status=$(internxt webdav status --json | jq -r '.success')
  if [ "$internxt_webdav_status" = "true" ]; then
    echo "WebDAV server online"
  else
    exit 1
  fi
fi

exit 0

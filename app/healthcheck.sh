#!/bin/sh
set -e

# Privilege Dropping
spath="$(readlink -f "$0")"
if [ "$(whoami)" = "root" ]; then
  exec su-exec appuser "$spath" "$@"
fi

# Internxt Login Check
internxt_whoami=$(internxt whoami --json | jq -r '.login.user.username')
if [ "$internxt_whoami" != "$INTERNXT_EMAIL" ]; then
  exit 1
fi

# WebDAV Server Status Check
if [ -f "/app/webdav.mode" ]; then
  internxt_webdav_status=$(internxt webdav status --json | jq -r '.message')
  if [ "${internxt_webdav_status#*: }" != "online" ]; then
    exit 1
  fi
fi

exit 0

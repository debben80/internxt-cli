#!/bin/sh
set -e
. /app/functions.sh

INTERNXT_EMAIL_VALUE=$(get_secure_var "INTERNXT_EMAIL" "true")
INTERNXT_PASSWORD_VALUE=$(get_secure_var "INTERNXT_PASSWORD" "true")
INTERNXT_TOTP_SECRET_VALUE=$(get_secure_var "INTERNXT_TOTP_SECRET")

PUID=${PUID:-1000}
PGID=${PGID:-1000}
if [ ! "$(id -u appuser)" -eq "${PUID}" ]; then
    usermod -o -u "${PUID}" appuser
fi
if [ ! "$(id -g appuser)" -eq "${PGID}" ]; then
    groupmod -o -g "${PGID}" appgroup
fi
chown -R appuser:appgroup /app

internxt_login
exec su-exec appuser "$@"

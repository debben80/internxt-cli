#!/bin/sh
set -e

get_secure_var() {
    local var_name="$1"
    local is_required="$2"
    local file_var_name="${var_name}_FILE"
    local value=""

    if [ -n "$(eval echo "\$$file_var_name")" ]; then
        file_path="$(eval echo "\$$file_var_name")"
        if [ -f "$file_path" ]; then
            value=$(cat "$file_path" | tr -d '\n')
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') Error : file ($file_path) doesn't exist." >&2
            exit 1
        fi
    else
        if [ -n "$(eval echo "\$$var_name")" ]; then
            value="$(eval echo "\$$var_name")"
        else
            if [ "$is_required" = "true" ]; then
                echo "$(date '+%Y-%m-%d %H:%M:%S') Error : $var_name or $file_var_name must be defined." >&2
                exit 1
            else
                echo "$(date '+%Y-%m-%d %H:%M:%S') Debug: $var_name is optional and not defined. Returning empty string." >&2
                value=""
            fi
        fi
    fi
    echo "$value"
}

internxt_login() {
    local internxt_cmd="internxt login -x -e \"$INTERNXT_EMAIL_VALUE\" -p \"$INTERNXT_PASSWORD_VALUE\""
    if [ -n "$INTERNXT_TOTP_SECRET_VALUE" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') Using 2FA-TOTP Login"
        INTERNXT_TOTP_CODE=$(oathtool --totp -b "$INTERNXT_TOTP_SECRET_VALUE")
        if [ -z "$INTERNXT_TOTP_CODE" ]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') Error: Failed to generate OTP from WEBDAV_TOTP_SECRET." >&2
            exit 1
        fi
        internxt_cmd="$internxt_cmd -w \"$INTERNXT_TOTP_CODE\""
    fi
    echo "$(date '+%Y-%m-%d %H:%M:%S') Login..."
    eval "$internxt_cmd"
    if [ $? -ne 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') Login failed" >&2:q
        exit 1
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') User $INTERNXT_EMAIL_VALUE Logged in."
    fi
}

INTERNXT_EMAIL_VALUE=$(get_secure_var "INTERNXT_EMAIL" "true")
INTERNXT_PASSWORD_VALUE=$(get_secure_var "INTERNXT_PASSWORD" "true")
INTERNXT_TOTP_SECRET_VALUE=$(get_secure_var "INTERNXT_TOTP_SECRET")
internxt_login

PUID=${PUID:-1000}
PGID=${PGID:-1000}
if [ ! "$(id -u appuser)" -eq "${PUID}" ]; then
    usermod -o -u "${PUID}" appuser
fi
if [ ! "$(id -g appgroup)" -eq "${PGID}" ]; then
    groupmod -o -g "${PGID}" appgroup
fi
chown -R appuser:appgroup /app
exec su-exec appuser "$@"
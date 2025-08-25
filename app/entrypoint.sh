#!/bin/sh
set -e

get_secure_var() {
    local var_name="$1"
    local file_var_name="${var_name}_FILE"
    local value=""

    if [ -n "$(eval echo "\$$file_var_name")" ]; then
        file_path="$(eval echo "\$$file_var_name")"
        if [ -f "$file_path" ]; then
            value=$(cat "$file_path" | tr -d '\n')
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') Error : file ($file_path) doesn't exist."
            exit 1
        fi
    elif [ -n "$(eval echo "\$$var_name")" ]; then
        value="$(eval echo "\$$var_name")"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') Error : $var_name or $file_var_name must be defined."
        exit 1
    fi
    echo "$value"
}

internxt_login() {
    local internxt_cmd="internxt login -x -e \"$INTERNXT_EMAIL_VALUE\" -p \"$INTERNXT_PASSWORD_VALUE\""
    if [ -n "$WEBDAV_TOTP_SECRET_VALUE" ]; then
        INTERNXT_TOTP_CODE=$(oathtool --totp -b "$INTERNXT_TOTP_SECRET_VALUE")

        if [[ -z "$INTERNXT_TOTP_CODE" ]]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') Error: Failed to generate OTP from WEBDAV_TOTP_SECRET."
            exit 1
        fi
        internxt_cmd="$internxt_cmd -w \"$INTERNXT_TOTP_CODE\""
    fi

    eval "$internxt_cmd"
    if [ $? -ne 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') Login failed" >&2
        exit 1
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') User $INTERNXT_EMAIL_VALUE Logged in."
    fi
}

internxt_webdav(){
    internxt webdav enable
}
internxt_watch(){
    tail -f /dev/null
}
if [ "$WEBDAV_ENABLE" = "true" ]; then
    echo "WebDAV server mode.."
    INTERNXT_EMAIL_VALUE=$(get_secure_var "INTERNXT_EMAIL")
    INTERNXT_PASSWORD_VALUE=$(get_secure_var "INTERNXT_PASSWORD")
    INTERNXT_TOTP_SECRET_VALUE=$(get_secure_var "INTERNXT_TOTP_SECRET")
    internxt_login
    internxt_webdav
    internxt_watch
else
    exec "$@"
fi
tail -f /dev/null
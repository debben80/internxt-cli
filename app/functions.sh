#!/bin/sh

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1"
}

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
            log "Error : file ($file_path) doesn't exist." >&2
            exit 1
        fi
    else
        if [ -n "$(eval echo "\$$var_name")" ]; then
            value="$(eval echo "\$$var_name")"
        else
            if [ "$is_required" = "true" ]; then
                log "Error : $var_name or $file_var_name must be defined." >&2
                exit 1
            else
                log "Debug: $var_name is optional and not defined. Returning empty string." >&2
                value=""
            fi
        fi
    fi
    echo "$value"
}

internxt_login() {
    local internxt_cmd="internxt login -x -e \"$INTERNXT_EMAIL_VALUE\" -p \"$INTERNXT_PASSWORD_VALUE\""
    if [ -n "$INTERNXT_TOTP_SECRET_VALUE" ]; then
        log "Using 2FA-TOTP Login"
        INTERNXT_TOTP_CODE=$(oathtool --totp -b "$INTERNXT_TOTP_SECRET_VALUE")
        if [ -z "$INTERNXT_TOTP_CODE" ]; then
            log "Error: Failed to generate OTP from WEBDAV_TOTP_SECRET." >&2
            exit 1
        fi
        internxt_cmd="$internxt_cmd -w \"$INTERNXT_TOTP_CODE\""
    fi
    log "Login..."
    eval "su-exec appuser $internxt_cmd"
    if [ $? -ne 0 ]; then
        log "Login failed" >&2
        exit 1
    else
        log "User $INTERNXT_EMAIL_VALUE Logged in."
    fi
}

internxt_webdav() {
    local webdav_config="internxt webdav-config"
    log "Configure WebDAV server..."
    if [ "$WEBDAV_PROTO" = "http" ]; then
        webdav_config="$webdav_config -h -p $WEBDAV_PORT"
    else
        webdav_config="$webdav_config -s -p $WEBDAV_PORT"
    fi
    eval "$webdav_config"
    if [ $? -ne 0 ]; then
        log "Configuring WebDAV server failed" >&2
        exit 1
    fi
    log "Start WebDAV server..."
    internxt webdav enable
    if [ $? -ne 0 ]; then
        log "Starting WebDAV server failed" >&2
        exit 1
    fi
}

internxt_watch() {
    export HEALTHCHECK_ENABLED=1
    log "WebDAV running..."
    local log_path=$(internxt logs --json | jq -r '.path')
    local log_file="internxt-webdav-error.log"
    if [ "$WEBDAV_LOGS" = "debug" ]; then
        log_file="internxt-webdav-combined.log"
    fi
    tail -f $log_path/$log_file
}

#!/bin/sh
set -e

internxt_webdav(){
    local webdav_config="internxt webdav-config"
    echo "$(date '+%Y-%m-%d %H:%M:%S') Configure WebDAV server..."
    if [ "$WEBDAV_PROTO" = "http" ]; then
        webdav_config="$webdav_config -h -p $WEBDAV_PORT"
    else
        webdav_config="$webdav_config -s -p $WEBDAV_PORT"
    fi
    eval "$webdav_config"
    if [ $? -ne 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') Configuring WebDAV server failed" >&2
        exit 1
    fi
    echo "$(date '+%Y-%m-%d %H:%M:%S') Start WebDAV server..."
    internxt webdav enable
    if [ $? -ne 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') Starting WebDAV server failed" >&2
        exit 1
    fi
}

internxt_watch(){
    echo "$(date '+%Y-%m-%d %H:%M:%S') WebDAV running..."
    ## to do
    local log_path=$(internxt logs --json | jq -r '.path')
    local log_file="internxt-webdav-error.log"
    if [ "WEBDAV_LOGS" = "debug" ]; then
        log_file="internxt-webdav-combined.log"
    fi
    tail -f $log_path/$log_file
}

WEBDAV_PROTO=${WEBDAV_PROTO:-https}
WEBDAV_PORT=${WEBDAV_PORT:-3005}
WEBDAV_LOGS=${WEBDAV_LOGS:-error}

echo "$(date '+%Y-%m-%d %H:%M:%S') WebDAV server mode..."
internxt_webdav
internxt_watch
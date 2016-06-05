#!/bin/bash
PORT=1979
PIDFILE=server.pid
LOGFILE=server.log
BASEURL="http://localhost:$PORT"

set -ex

./build.sh

stop-server() {
    if [[ -e "$PIDFILE" ]];then
        pkill -P "$(cat $PIDFILE)"
        rm "$PIDFILE"
    fi
}

start-server() {
    echo > "$LOGFILE"
    ./build/run_translation-server.sh -port "$PORT" >> "$LOGFILE" 2>&1 & echo "$!" > $PIDFILE
    echo "Started Server on port $PORT ($(cat $PIDFILE))"
    trap 'stop-server' EXIT INT TERM
    sleep 2
}

start-server
curl "$BASEURL/export?format=wikipedia" \
    -X "POST" \
    -H "Content-Type:application/json" \
    -d@assets/10.1080_15424060903167229.json

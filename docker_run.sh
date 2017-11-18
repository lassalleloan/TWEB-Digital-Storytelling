#!/bin/bash

HOST="127.0.0.1"

uname="$(uname -s)"
case "${uname}" in
    Linux*)
        BROWSER=xdg-open;;
    *)
        BROWSER=open
esac

function stop_all {
    echo "Stopping all launched container"
    docker kill $(docker ps -aq) 2>/dev/null && docker rm $(docker ps -aq) 2>/dev/null && docker volume rm $(docker volume ls -q) 2>/dev/null
}

function docker_run {
    local site_port=8080

    echo "Run docker infrastructure"

    docker build -t php/php .
    docker run -d --name php -p 8080:80 php/php
    $BROWSER "http://$HOST:$site_port/"
}

# Main

# Stop old containers
stop_all

# Launch containers
docker_run

# Stop current containers after user action
read -p "Press any key to stop all docker container ..."
stop_all

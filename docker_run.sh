#!/bin/bash

HOST="172.17.0.1"

if [ -z ${WINDIR+x} ]
then
    BROWSER=xdg-open
else
    BROWSER=start
fi

function stop_all {
    echo "Stopping all launched container"
    docker kill $(docker ps -aq)
    docker rm $(docker ps -aq)
}

function docker_run {
    local site_port=8080

    echo "Run docker infrastructure"

    docker build -t php/php .
    docker run -d --name php -p 8080:80 php/php
    $BROWSER "http://$HOST:$site_port/"
}

# Main
stop_all # stop old containers
docker_run # launch containers

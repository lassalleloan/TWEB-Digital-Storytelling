#!/bin/bash
#
# Start php/apache docker container and open browser 
# author: Loan Lassalle

HOST=127.0.0.1
PORT_HOST=8080
BROWSER=open

# Open OS default browser
case "$OSTYPE" in
    darwin*)
        BROWSER=open;;
    linux*)
        BROWSER=xdg-open;;
    msys*)
        BROWSER=start;;
    *)
        echo "unknown: $OSTYPE" 
        exit 0;;
esac

# Start container
function start {
    echo "Starting php/apache docker container"
    docker build -t php/apache .
    docker run --rm -d --name php-apache -p $PORT_HOST:80 php/apache
    $BROWSER "http://${HOST}:${PORT_HOST}/"
}

# Stop container
function stop {
    echo "Stopping all docker container"
    docker kill $(docker ps -aq) 2>/dev/null && docker rm $(docker ps -aq) 2>/dev/null && docker volume rm $(docker volume ls -q) 2>/dev/null
    #docker rmi -f $(docker images | tr -s '       ' ' ' | cut -d ' ' -f 3) 2>/dev/null
}

# Main
stop
start
read -p "Press any key to stop all docker container ..."
stop

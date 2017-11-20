#!/bin/bash
#
# Start ${IMAGE_TAG} docker container
# author: Loan Lassalle

IMAGE_TAG="php/apache"
CONTAINER_NAME="php-apache"

IP_HOST="127.0.0.1"
PORT_HOST="8080"

# Open OS default browser
function open_browser {
    local os_type="${1}"
    local ip_host="${2}"
    local port_host="${3}"
    local browser=""

    case "${os_type}" in
        darwin*)
            browser="open";;
        linux*)
            browser="xdg-open";;
        msys*)
            browser="start";;
        *)
            echo "unknown: ${os_type}" 
            exit 0;;
    esac

    echo "Open OS default browser"
    "${browser}" "http://${ip_host}:${port_host}/"
}

# Start container
function start {
    local imageTag="${1}"
    local container_name="${2}"
    local port_host="${3}"

    echo "Starting ${container_name} docker container"
    docker build \
        --force-rm \
        --quiet \
        --tag "${imageTag}" .
    docker run \
        --detach \
        --name "${container_name}" \
        --rm \
        --publish ${port_host}:80 \
        "${imageTag}"
}

# Stop container
function stop {
    local container_name="${1}"

    echo "Stopping ${container_name} docker container"
    docker stop "${container_name}" 2>/dev/null
    docker kill "${container_name}" 2>/dev/null
    docker rm \
        --volumes "${container_name}" 2>/dev/null

    #docker stop ${container_name} 2>/dev/null && docker kill ${container_name} 2>/dev/null && docker rm --volumes ${container_name} 2>/dev/null && docker volume rm --force ${volume_name} 2>/dev/null && docker image rm --force ${image_tag} 2>/dev/null
    #docker stop $(docker ps --all --quiet) 2>/dev/null && docker kill $(docker ps --all --quiet) 2>/dev/null && docker rm --volumes $(docker ps --all --quiet) 2>/dev/null && docker volume rm --force $(docker volume ls --quiet) 2>/dev/null && docker image rm --force $(docker images --all --quiet) 2>/dev/null
    #docker volume prune --force 2>/dev/null && docker image prune --force 2>/dev/null
}

# Main
start "${IMAGE_TAG}" "${CONTAINER_NAME}" "${PORT_HOST}"
open_browser "${OSTYPE}" "${IP_HOST}" "${PORT_HOST}"
read -p "Press any key to stop all docker container ..."
stop "${CONTAINER_NAME}"

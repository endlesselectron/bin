#!/bin/sh

docker \
    run \
    --restart always \
    --interactive \
    --tty \
    --detach \
    --privileged \
    --net host \
    --env DISPLAY \
    --volume /tmp/.X11 \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --volume ${1}:/usr/local/src \
    fedora:24 bash &&
    docker \
    run \
    --interactive \
    --tty \
    --detach \
    --env PROJECT_NAME="fedora" \
    --env PROJECT_COMMAND="docker exec --interactive --tty $(docker ps -q --latest) sh -c \"cd /usr/local/src && bash\"" \
    --volume dot_ssh:/workspace \
    --privileged \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --publish-all \
    emorymerryman/cloud9:3.0.0 &&
    docker ps --latest &&
    true
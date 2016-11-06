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
    alpine:3.4 sh &&
    docker \
    run \
    --interactive \
    --tty \
    --detach \
    --env PROJECT_NAME="alpine" \
    --env PROJECT_COMMAND="docker exec --interactive --tty $(docker ps -q --latest) sh -c \"cd /root && sh\"" \
    --volume dot_ssh:/workspace \
    --privileged \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --publish-all \
    emorymerryman/cloud9:3.0.0 &&
    docker ps --latest &&
    true
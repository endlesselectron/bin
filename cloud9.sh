#!/bin/sh

docker run --interactive --tty --rm \
    --env BIN_URL=git@github.com:endlesselectron/bin.git \
    --env BIN_TAG=${3} \
    --env PROJECT_UPSTREAM=${1} \
    --env PROJECT_ORIGIN=${2} \
    --env GIT_EMAIL=emory.merryman@gmail.com \
    --env GIT_NAME="Emory Merryman" \
    --env UUID=$(uuidgen) \
    --volume dot_ssh:/root/.ssh \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --privileged \
    --env DISPLAY \
    --volume /tmp/.X11 \
    --publish-all \
    --env DOCKER_API_VERSION=1.22 \
    emorymerryman/cloud9:2.2.0
#!/bin/sh

docker run --interactive --tty --rm \
    --env BIN_URL=git@github.com:endlesselectron/bin.git \
    --env BIN_TAG=0.0.0 \
    --env PROJECT_UPSTREAM=git@github.com:tidyrailroad/cloud9.git \
    --env PROJECT_ORIGIN=git@github.com:tidyrailroad/cloud9.git \
    --env GIT_EMAIL=emory.merryman@gmail.com \
    --env GIT_NAME="Emory Merryman" \
    --env DISPLAY=10.0.2.15:0 \
    --env DOCKER_API_VERSION=1.22 \
    --volume dot_ssh:/root/.ssh:ro \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --volume /tmp/.X11-unix/X0:/tmp/.X11-unix/X0:rw \
    --publish-all \
    emorymerryman/cloud9:2.1.3
#!/bin/sh

docker run \
    --interactive \
    --tty \
    --rm \
    --env DISPLAY \
    --volume /tmp/.X11-unix \
    --net host \
    --privileged \
    emorymerryman/meld:0.0.2 \
    &&
    true
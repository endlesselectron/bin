#!/bin/sh

docker run \
    --interactive \
    --tty \
    --rm \
    --volume $(docker inspect $(self.sh) | grep -B 2 '"Destination": "/root/workspace",' | head --lines 1 | cut --fields 4 --delimiter '"'):/root/workspace \
    --workdir ${BASE_PROC} \
    --privileged \
    --volume /tmp/.X11-unix --env DISPLAY \
    --net host \
    emorymerryman/meld:0.0.2 &&
    true
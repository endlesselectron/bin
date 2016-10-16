#!/bin/sh

docker run \
    --interactive \
    --tty \
    --rm \
    --volume ad298239361c0e5ad01bcd4d9946790bb0205aaccbc2b07441004ba9c281aa6d:/root/workspace \
    --workdir /root/workspace/bin \
    --privileged \
    --volume /tmp/.X11-unix --env DISPLAY \
    --net host \
    emorymerryman/meld:0.0.2 &&
    true
#!/bin/bash

docker \
    run \
    --interactive \
    --tty \
    --detached \
    --env CONTAINER_ID=$(self.sh)
    emorymerryman/shutdown:0.0.0 &&
    true
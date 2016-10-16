#!/bin/bash

docker ps -q | while read CID
    do
        docker inspect ${CID} | grep "UUID="
        true
    done &&
    docker run -it --rm --env DISPLAY --net=host --privileged emacs &&
    true
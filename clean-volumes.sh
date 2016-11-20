#!/bin/sh

docker volume ls -q --filter=dangling=true | while read VOLUME
do
    docker volume rm -f -v ${VOLUME} &&
        true
done &&
true
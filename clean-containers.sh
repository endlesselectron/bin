#!/bin/sh

docker ps -q | while read CONTAINER_ID
do
    docker stop ${CONTAINER_ID} &&
    docker rm -f -v ${CONTAINER_ID} &&
    true
done &&
true
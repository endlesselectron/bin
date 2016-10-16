#!/bin/sh

docker ps -q | while read CID
do
    docker inspect ${CID} | grep ${UUID} > /dev/null &&
        echo ${CID} &&
        true
done &&
    true
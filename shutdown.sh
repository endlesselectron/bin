#!/bin/sh

docker run --interactive --tty --detach --env CONTAINER_ID=$(cat /root/cid) emorymerryman/shutdown:0.0.0 &&
    true
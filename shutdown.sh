#!/bin/sh

docker run --interactive --tty --detach --env CONTAINER_ID emorymerryman/shutdown:0.0.0 &&
    true
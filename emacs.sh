#!/bin/bash

docker run -it --rm --env DISPLAY=:0 --net=host --privileged emacs &&
    true
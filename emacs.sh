#!/bin/bash

docker run -it --rm --env DISPLAY --net=host --privileged emacs &&
    true
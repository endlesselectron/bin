#!/bin/sh

docker inspect $(self.sh) | grep -B 2 "\"Destination\": \"/root/workspace\"" | head --lines 1 | cut --fields 4 --delimiter "\"" &&
    true
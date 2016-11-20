#!/bin/sh

docker run --interactive --rm --volume ${1}:/usr/local/src alpine:3.4 tee /usr/local/src/${2} &&
    true
    
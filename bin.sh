#!/bin/sh

./cloud9.sh \
    --project-name bin \
    --upstream git@github.com:endlesselectron/bin.git\
    --origin git@github.com:endlesselectron/bin.git\
    --email emory.merryman@gmail.com \
    --name "Emory Merryman" \
    --parent develop \
    &&
    true
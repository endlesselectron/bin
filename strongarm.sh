#!/bin/sh

./cloud9.sh \
    --project-name strongarm \
    --upstream git@github.com:tidyrailroad/strongarm.git \
    --origin git@github.com:tidyrailroad/strongarm.git \
    --email emory.merryman@gmail.com \
    --name "Emory Merryman" \
    --parent develop \
    &&
    true
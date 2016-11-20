#!/bin/sh

git fetch upstream develop &&
    git checkout -b scratch/$(uuidgen) &&
    git reset --soft upstream/develop &&
    git commit &&
    true
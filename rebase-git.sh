#!/bin/sh

git fetch upstream develop &&
    git checkout -b scratch/$(uuidgen) &&
    git rebase upstream/develop &&
    git commit &&
    true
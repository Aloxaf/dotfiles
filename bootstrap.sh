#!/usr/bin/bash

for i in */; do
    if stow "${i%%/}" --ignore=.directory; then
        echo 'ok'
    else
        echo 'failed'
    fi
done

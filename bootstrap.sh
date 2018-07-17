#!/usr/bin/bash

for i in */;
do
    if stow ${i%%/}; then
        echo 'ok'
    else
        echo 'failed'
    fi
done
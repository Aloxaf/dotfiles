#!/usr/bin/zsh

local root_dirs=(etc usr)

function deploy_to_root() {
    local i
    for i (`ls "$1"`) {
        if [[ $root_dir[(I)$i] != 0 ]] {
            return 0
        }
    }
    return 1
}

for i (*/) {
    echo -n "deploying ${i%/}"
    if {deploy_to_root ${i%/}} {
        echo " to /"
        sudo stow "${i%/}" --ignore=.directory --target=/
    } else {
        echo " to $HOME"
        stow "${i%/}" --ignore=.directory --target=$HOME
    }
}

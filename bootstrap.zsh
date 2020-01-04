#!/usr/bin/zsh

setopt extended_glob no_nomatch

function deploy_to_root() {
    local -a file=($1/*(#q:t))
    [[ -d "/$file[1]" ]]
}

for i (^systemd(/)) {
    echo -n "deploying $i"
    if { deploy_to_root $i } {
        echo " to /"
        sudo stow "$i" --ignore=.directory --target=/
    } else {
        echo " to $HOME"
        stow "$i" --ignore=.directory --target=$HOME
    }
}

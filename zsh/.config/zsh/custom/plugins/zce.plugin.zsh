function zce() {
    [[ -z $BUFFER ]] && zle up-history
    with-zce zce-raw zce-searchin-read
}

zle -A zce zce
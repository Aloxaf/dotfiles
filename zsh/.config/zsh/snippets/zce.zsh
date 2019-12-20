function zce() {
    [[ -z $BUFFER ]] && zle up-history
    with-zce zce-raw zce-searchin-read
}

zle -A zce zce
bindkey "\C-w" kill-region

function add-bracket() {
    BUFFER[$CURSOR+1]="($BUFFER[$CURSOR+1]"
    BUFFER+=')'
}
zle -N add-bracket
bindkey "\e(" add-bracket

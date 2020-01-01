# alias-tips 太慢了, you-shoudle-use 不会展开已有别名

ALIAS_TIPS_BUFFER=''

function _check_alias() {
    local raw="${(z)1}" expand="${(z)3}"
    local result tmp

    for k v (${(kv)aliases}) {
        if [[ $expand == "$v "* || $expand == $v ]] {
            tmp=${expand/$v/$k}
            if (( $#tmp < $#result || ! $#result )) {
                result=$tmp
            }
        }
        if [[ $raw == "$v "* || $raw == $v ]] {
            tmp=${raw/$v/$k}
            if (( $#tmp < $#result || ! $#result )) {
                result=$tmp
            }
        }
    }
    if (( $#raw > $#result )) {
        ALIAS_TIPS_BUFFER=$result
    }
}

function _show_alias_tips() {
    if [[ -n $ALIAS_TIPS_BUFFER ]] {
        print -P "%F{yellow}%BTips: you can use %b%f%K{cyan}%F{black}\$ALIAS_TIPS_BUFFER%f%k"
    }
    ALIAS_TIPS_BUFFER=
}

add-zsh-hook preexec _check_alias
add-zsh-hook precmd  _show_alias_tips

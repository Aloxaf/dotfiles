# alias-tips 太慢了, you-shoudle-use 不会展开已有别名

ALIAS_TIPS_BUFFER=''

function _check_alias() {
    setopt local_options extended_glob
    local raw=$1 expand=$2
    local result1 result2 tmp

    for k v (${(kv)aliases}) {
        if [[ ${(M)raw# #$v } ]] {
            tmp=${raw/$v/$k}
            if (( $#tmp < $#result1 || ! $#result1 )) {
                result1=$tmp
            }
        }
        if [[ $expand == "$v "* ]] {
            tmp=${expand/$v/$k}
            if (( $#tmp < $#result1 || ! $#result1 )) {
                result1=$tmp
            }
        }
    }

    result2=$result1
    for k v (${(kv)galiases}) {
        if [[ $result1 == $v* ]] {
            # FIXME: 此处会将引号内的也一并替换, 不过大多数时候也没啥问题...大概
            tmp=${result1//$v/$k}
            if (( $#tmp < $#result2 || ! $#result2 )) {
                result2=$tmp
            }
        }
    }
    if [[ -n ${raw## #$result2 #} ]] && (( $#raw > $#result2 )) {
        ALIAS_TIPS_BUFFER=$result2
    }
}

function _show_alias_tips() {
    if [[ -n $ALIAS_TIPS_BUFFER ]] {
        print -P "%F{yellow}%BTips: you can use '\$ALIAS_TIPS_BUFFER'%b%f"
    }
    ALIAS_TIPS_BUFFER=
}

add-zsh-hook preexec _check_alias
add-zsh-hook precmd  _show_alias_tips

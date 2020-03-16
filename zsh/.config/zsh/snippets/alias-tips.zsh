# alias-tips 太慢了, you-shoudle-use 不会展开已有别名

ALIAS_TIPS_BUFFER=''

function init_alias_list() {
    typeset -g -A alias_list
    (( $#alias_list != 0 )) && return

    local k v cmds
    for k v (${(kv)aliases}) {
        expand_alias cmds ${(z)v}
        alias_list[$k]=$cmds
    }
}

function _check_alias() {
    local expand="${(z)3}"
    local result tmp k v

    init_alias_list

    for k v (${(kv)alias_list}) {
        if [[ $expand == "$v "* || $expand == $v ]] {
            tmp=${expand/$v/$k}
            if (( $#tmp < $#result || ! $#result )) {
                result=$tmp
            }
        }
    }

    if (( ${#${1%% #}} > $#result )) {
        ALIAS_TIPS_BUFFER=$result
    }
}

function _show_alias_tips() {
    if [[ -n $ALIAS_TIPS_BUFFER ]] {
        print -P "%B%F{yellow}Tips: you can use %f%K{011}%F{016}\$ALIAS_TIPS_BUFFER%f%k%b"
    }
    ALIAS_TIPS_BUFFER=
}

add-zsh-hook preexec _check_alias
add-zsh-hook precmd  _show_alias_tips

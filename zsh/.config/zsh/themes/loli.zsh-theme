# 参考资料
# https://stackoverflow.com/questions/19901044/what-is-k-f-in-oh-my-zsh-theme
# https://stackoverflow.com/questions/4466245/customize-zshs-prompt-when-displaying-previous-command-exit-code
# https://zhuanlan.zhihu.com/p/51008087
# https://www.manpagez.com/man/1/zshmisc/

function _fish_collapsed_pwd() {
    if [[ "$PWD" == "$HOME" ]] {
        echo "~"
        return
    } elif [[ "$PWD" == "/" ]] {
        echo "/"
        return
    }
    local pwd="${PWD/$HOME/~}"
    local names=("${(s:/:)pwd}")
    local length=${#names}
    for i ({1..$[length-1]}) {
        local name=$names[$i]
        if [[ $name[1] == "." ]] {
            names[$i]=$name[1,2]
        } else {
            names[$i]=$name[1]
        }
    }
    echo ${(j:/:)names}
}

PROMPT="%(?.%F{cyan}.%F{red})%B$> %f%b"
PROMPT2="$fg_bold[yellow]? $reset_color"
RPROMPT='%F{blue}$(_fish_collapsed_pwd)%f'

setopt prompt_subst

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

ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"


async_init
async_start_worker get_git_prompt -n

function set_prompt() {
    local output=$3
    if [[ $output != "" ]] {
        RPROMPT="%F{blue}$(_fish_collapsed_pwd)$output%f"
    } else {
        RPROMPT="%F{blue}$(_fish_collapsed_pwd)%f"
    }
    zle && zle reset-prompt
    async_job get_git_prompt git_prompt_info
}

async_register_callback get_git_prompt set_prompt

async_job get_git_prompt git_prompt_info

#TMOUT=1
#TRAPALRM() { zle reset-prompt }


PROMPT="%(?.%F{cyan}.%F{red})%B$> %f%b"
PROMPT2="$fg_bold[yellow]? $reset_color"
RPROMPT='%F{blue}$(_fish_collapsed_pwd)%f'

setopt prompt_subst

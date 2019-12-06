# combined by avit and kardan

function get_host {
    echo '@'$HOST
}

PROMPT='-  ⃢ —  ⃢ - %~$(git_prompt_info)
   ∙ ∙    ▶ '
PROMPT2='◀ '
RPROMPT='%*'

ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
local _return_status="%{$fg_bold[red]%}%(?..⍉)%{$reset_color%}"

setopt prompt_subst

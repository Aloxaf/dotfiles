0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

autoload -Uz ${0:h}/{expand_alias,init_alias_list,_check_alias,_show_alias_tips}
autoload -Uz add-zsh-hook

add-zsh-hook preexec _check_alias
add-zsh-hook precmd  _show_alias_tips

typeset -g ALIAS_TIPS_BUFFER

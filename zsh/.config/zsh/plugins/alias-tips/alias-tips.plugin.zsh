0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

autoload -Uz ${0:h}/_altp_*
autoload -Uz add-zsh-hook

add-zsh-hook preexec _altp_check
add-zsh-hook precmd  _altp_show_tips

typeset -g ALIAS_TIPS_BUFFER

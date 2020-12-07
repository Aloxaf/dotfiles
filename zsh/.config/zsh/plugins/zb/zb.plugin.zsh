0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"y

autoload -Uz ${0:h}/{zb,_zb}
compdef _zb zb

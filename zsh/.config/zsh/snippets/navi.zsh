_call_navi() {
   local -r buff="$BUFFER"
   local -r r="$(printf "$(navi --print </dev/tty)")"
   zle kill-whole-line
   zle -U "${buff}${r}"
}

# 跳转到下一个 (*) 的位置
_navi_next_pos() {
    local -i pos=$BUFFER[(ri)\(*\)]-1
    BUFFER=${BUFFER/${BUFFER[(wr)\(*\)]}/}
    CURSOR=$pos
}

zle -N _call_navi
zle -N _navi_next_pos

bindkey '^[c' _call_navi
bindkey '^[n' _navi_next_pos

function sk-zjump-widget() {
    # 优先级: 匹配程度 > 目录权重 > 匹配位置(末端)
    local selected=$(z | sk --color=dark,current_bg:23 --tiebreak score,-index,end)
    if [[ "$selected" != "" ]] {
        builtin cd "${selected[(w)2]}"
    }
    zle reset-prompt
}
zle     -N    sk-zjump-widget
bindkey '\ec' sk-zjump-widget

function sk-history-widget() {
    local selected=$(fc -rl 1 | sk --color=dark,current_bg:23 --tiebreak score,index,end)
    if [[ "$selected" != "" ]] {
        zle vi-fetch-history -n $selected
    }
}

zle     -N   sk-history-widget
bindkey '^R' sk-history-widget

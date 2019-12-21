export FZF_DEFAULT_OPTS='--color=bg+:23'

# 快速目录跳转, M-c 触发
function fz-zjump-widget() {
    local selected=$(z | fzf -n "2.." --tiebreak=end,index --tac --prompt="jump> ")
    if [[ "$selected" != "" ]] {
        builtin cd "${selected[(w)2]}"
    }
    zle reset-prompt
}

zle     -N    fz-zjump-widget
bindkey '\ec' fz-zjump-widget

# 搜索历史, C-r 触发
function fz-history-widget() {
    local selected=$(fc -rl 1 | fzf -n "2.." --tiebreak=index --prompt="cmd> ")
    if [[ "$selected" != "" ]] {
        zle vi-fetch-history -n $selected
    }
}

zle     -N   fz-history-widget
bindkey '^R' fz-history-widget

# 搜索文件, M-s 触发
# 会将 * 或 ** 替换为搜索结果
# 前者表示搜索单层, 后者表示搜索子目录
function fz-find() {
    local selected dir cut
    cut=$(grep -oP '[^* ]+(?=\*{1,2}$)' <<< $BUFFER)
    eval "dir=${cut:-.}"
    if [[ $BUFFER == *"**"* ]] {
        selected=$(fd -H . $dir | fzf --tiebreak=end,length --prompt="cd> ")
    } elif [[ $BUFFER == *"*"* ]] {
        selected=$(fd -d 1 . $dir | fzf --tiebreak=end --prompt="cd> ")
    }
    BUFFER=${BUFFER/%'*'*/}
    BUFFER=${BUFFER/%$cut/$selected}
    zle end-of-line
}

zle     -N    fz-find
bindkey '\es' fz-find

# 依赖 Valodim/zsh-capture-completion
# 利用 fzf 补全参数
function fzf-completion() {
    local selected left_non_space clist
    clist=("${(@f)$(zcapture "$LBUFFER")}")
    if (( $#clist == 1 )) {
        zle expand-or-complete
        return
    } else {
        selected=$(printf '%s\n' "${clist[@]}" | fzf --border --layout=reverse --tiebreak=begin --bind tab:down,ctrl-i:down,ctrl-j:accept --height=30%)
    }
    LBUFFER="${LBUFFER% *} ${selected% -- *}"
    LBUFFER=${LBUFFER%$'\x0d'}
    zle reset-prompt
}

zle     -N   fzf-completion
bindkey '^I' fzf-completion

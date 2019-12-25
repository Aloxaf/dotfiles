bindkey -e  # Emacs 键绑定

# C-v + 按键 以查看特殊按键的转义序列
bindkey '^[[1;5C' forward-word   # C-Right
bindkey '^[[1;3C' forward-word   # M-Right
bindkey '^[[1;5D' backward-word  # C-Left
bindkey '^[[1;3D' backward-word  # M-Left
bindkey ' ' magic-space  # 按空格展开历史

# https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/key-bindings.zsh 写得很复杂
# 有点不明白为什么, 感觉是历史遗留问题的样子, 暂时就这样吧, 出问题了再改
# https://stackoverflow.com/questions/31641910/why-is-terminfokcuu1-eoa

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search    # Uo
bindkey "^[[B" down-line-or-beginning-search  # Down

export FZF_DEFAULT_OPTS='--color=bg+:23'

# fuzzy 相关绑定 {{{1
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
bindkey '\C-r' fz-history-widget

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
# }}}1

# ZLE 相关 {{{1

# 行内光标跳转 {{{2

# C-j 被征用为 prefix
bindkey -r "^J"

# C-j c 快速跳转到指定字符
function zce-jump-char() {
    [[ -z $BUFFER ]] && zle up-history
    zstyle ':zce:*' prompt-char '%B%F{green}Jump to character:%F%b '
    zstyle ':zce:*' prompt-key '%B%F{green}Target key:%F%b '
    with-zce zce-raw zce-searchin-read
}
zle -N zce-jump-char
bindkey "^Jc" zce-jump-char

# C-j d 删除到指定字符
function zce-delete-to-char() {
    [[ -z $BUFFER ]] && zle up-history
    local pbuffer=$BUFFER pcursor=$CURSOR
    local keys=${(j..)$(print {a..z} {A..Z})}
    zstyle ':zce:*' prompt-char '%B%F{yellow}Delete to character:%F%b '
    zstyle ':zce:*' prompt-key '%B%F{yellow}Target key:%F%b '
    zce-raw zce-searchin-read $keys

    if (( $CURSOR < $pcursor ))  {
        pbuffer[$CURSOR,$pcursor]=$pbuffer[$CURSOR]
    } else {
        pbuffer[$pcursor,$CURSOR]=$pbuffer[$pcursor]
        CURSOR=$pcursor
    }
    BUFFER=$pbuffer
}
zle -N zce-delete-to-char
bindkey "^Jd" zce-delete-to-char

# }}}2

# 快速添加括号
function add-bracket() {
    BUFFER[$CURSOR+1]="($BUFFER[$CURSOR+1]"
    BUFFER+=')'
}
zle -N add-bracket
bindkey "\e(" add-bracket

# 快速跳转到上级目录: ... => ../..
# https://grml.org/zsh/zsh-lovers.html
function rationalise-dot() {
    if [[ $LBUFFER = *.. ]] {
        LBUFFER+=/..
    } else {
        LBUFFER+=.
    }
}
zle -N rationalise-dot
bindkey . rationalise-dot

# 快速执行当前 BUFFER
function eval-buffer() {
    echoti sc
    echoti cud 1
    echoti hpa 0 2>/dev/null || echo -n '\x1b[1G'
    echoti el
    eval $BUFFER
    echoti hpa 0 2>/dev/null || echo -n '\x1b[1G'
    echoti el
    echoti rc
}
#zle -N eval-buffer
#bindkey "\ee" eval-buffer

# 记住上一条命令的 CURSOR 位置 {{{2
function cached-accept-line() {
    _last_cursor=$CURSOR
    zle accept-line
}
zle -N cached-accept-line
bindkey "^M" cached-accept-line

function prev-cache-buffer() {
    local pbuffer=$BUFFER
    zle up-line-or-beginning-search
    if [[ -n $_last_cursor && -z $pbuffer ]] {
        CURSOR=$_last_cursor
        _last_cursor=
    }
}
zle -N prev-cache-buffer
bindkey "^P" prev-cache-buffer
bindkey "^N" down-line-or-beginning-search
# }}}2
# }}}1

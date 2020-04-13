# 参考资料:
# http://zshwiki.org/home/#reading_terminfo
# https://stackoverflow.com/questions/31641910/why-is-terminfokcuu1-eoa
# https://www.reddit.com/r/zsh/comments/eblqvq/del_pgup_and_pgdown_input_in_terminal/fb7337q/

bindkey -e  # Emacs 键绑定

# make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )) {
    function zle-line-init() {
        echoti smkx
    }
    function zle-line-finish() {
        echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
}

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

ebindkey 'Home'   beginning-of-line
ebindkey 'End'    end-of-line
ebindkey 'Delete' delete-char
ebindkey "Up"     up-line-or-beginning-search
ebindkey "Down"   down-line-or-beginning-search

ebindkey "C-Right" forward-word
ebindkey 'C-Left'  backward-word
ebindkey "C-Backspace" backward-kill-word
ebindkey 'Space' magic-space  # 按空格展开历史
ebindkey 'C-d'   delete-char  # 不需要触发补全的功能
ebindkey 'C-w'   kill-region

# 单行模式下将当前内容入栈开启一个临时 prompt
# 多行模式下允许编辑前面的行
ebindkey 'M-q' push-line-or-edit

ebindkey -M command "Backspace" backward-delete-char

# 按参数边界跳转
# 参考 https://blog.lilydjwg.me/2013/11/14/zsh-move-by-shell-arguments.41712.html
() {
    local -a to_bind=(forward-word backward-word backward-kill-word)
    local widget
    for widget ($to_bind) {
        autoload -Uz $widget-match
        zle -N $widget-match
    }
    zstyle ':zle:*-match' word-style shell
}
ebindkey 'M-Right' forward-word-match
ebindkey 'M-Left'  backward-word-match
ebindkey "C-Backspace" backward-kill-word-match

# fuzzy 相关绑定 {{{1
# 快速目录跳转
# function fz-zjump-widget() {
#     local selected=$(z -l | fzf -n "2.." --tiebreak=end,index --tac --prompt="jump> ")
#     if [[ "$selected" != "" ]] {
#         builtin cd "${selected[(w)2]}"
#     }
#     zle push-line
#     zle accept-line
# }
# zle -N fz-zjump-widget
# ebindkey 'M-c' fz-zjump-widget

# 搜索历史
function fz-history-widget() {
    local selected=$(fc -rl 1 | fzf -n "2.." --tiebreak=index --prompt="cmd> " ${BUFFER:+-q$BUFFER})
    if [[ "$selected" != "" ]] {
        zle vi-fetch-history -n $selected
    }
}
zle -N fz-history-widget
ebindkey 'C-r' fz-history-widget

# 搜索文件
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
zle -N fz-find
ebindkey 'M-s' fz-find
# }}}1

# ZLE 相关 {{{1

# zce {{{2
# 快速跳转到指定字符
function zce-jump-char() {
    [[ -z $BUFFER ]] && zle up-history
    zstyle ':zce:*' prompt-char '%B%F{green}Jump to character:%F%b '
    zstyle ':zce:*' prompt-key '%B%F{green}Target key:%F%b '
    with-zce zce-raw zce-searchin-read
}
zle -N zce-jump-char
ebindkey "M-j" zce-jump-char

# 删除到指定字符
# function zce-delete-to-char() {
#     [[ -z $BUFFER ]] && zle up-history
#     local pbuffer=$BUFFER pcursor=$CURSOR
#     local keys=${(j..)$(print {a..z} {A..Z})}
#     zstyle ':zce:*' prompt-char '%B%F{yellow}Delete to character:%F%b '
#     zstyle ':zce:*' prompt-key '%B%F{yellow}Target key:%F%b '
#     zce-raw zce-searchin-read $keys
# 
#     if (( $CURSOR < $pcursor ))  {
#         pbuffer[$CURSOR,$pcursor]=$pbuffer[$CURSOR]
#     } else {
#         pbuffer[$pcursor,$CURSOR]=$pbuffer[$pcursor]
#         CURSOR=$pcursor
#     }
#     BUFFER=$pbuffer
# }
# zle -N zce-delete-to-char
# ebindkey "C-j d" zce-delete-to-char

# }}}2

# 快速添加括号 {{{2
function add-bracket() {
    BUFFER[$CURSOR+1]="($BUFFER[$CURSOR+1]"
    BUFFER+=')'
}
zle -N add-bracket
ebindkey "M-(" add-bracket
# }}}2

# 快速跳转到上级目录: ... => ../.. {{{2
# https://grml.org/zsh/zsh-lovers.html
function rationalise-dot() {
    if [[ $LBUFFER = *.. ]] {
        LBUFFER+=/..
    } else {
        LBUFFER+=.
    }
}
zle -N rationalise-dot
ebindkey "." rationalise-dot
# }}}2

# 记住上一条命令的 CURSOR 位置 {{{2
# function cached-accept-line() {
#     _last_cursor=$CURSOR
#     zle .accept-line
# }
# zle -N accept-line cached-accept-line
# ebindkey "C-m" accept-line

# function prev-buffer-or-beginning-search() {
#     local pbuffer=$BUFFER
#     zle up-line-or-beginning-search
#     if [[ -n $_last_cursor && -z $pbuffer ]] {
#         CURSOR=$_last_cursor
#         _last_cursor=
#     }
# }
# zle -N prev-buffer-or-beginning-search
# 连续上翻有问题
# ebindkey "C-p" prev-buffer-or-beginning-search
# ebindkey "Up"  prev-buffer-or-beginning-search
# }}}2

# 用编辑器编辑当前行 {{{2
autoload -U edit-command-line
function edit-command-line-as-zsh {
    TMPSUFFIX=.zsh
    edit-command-line
    unset TMPSUFFIX
}
zle -N edit-command-line-as-zsh
ebindkey 'C-x C-e' edit-command-line-as-zsh
# }}}2

# }}}1

# 棒棒 M-x
function execute-command() {
    local selected=$(printf "%s\n" ${(k)widgets} | fzf --reverse --prompt="cmd> " --height=10 )
    zle redisplay
    [[ $selected ]] && zle $selected
}
zle -N execute-command
ebindkey "M-x" execute-command

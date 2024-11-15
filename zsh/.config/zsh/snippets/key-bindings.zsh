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

local -A keybindings=(
    'Home'   beginning-of-line
    'End'    end-of-line
    'Delete' delete-char
    'Up'     up-line-or-beginning-search
    'Down'   down-line-or-beginning-search

    'C-Right'     forward-word
    'C-Left'      backward-word
    'C-Backspace' backward-kill-word
    'Space' magic-space  # 按空格展开历史
    'C-d'   delete-char  # 不需要触发补全的功能
    'C-w'   kill-region

    # 单行模式下将当前内容入栈开启一个临时 prompt
    # 多行模式下允许编辑前面的行
    'M-q' push-line-or-edit

    'C-j' self-insert-unmeta
)

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
keybindings+=(
    'M-Right' forward-word-match
    'M-Left'  backward-word-match
    'C-Backspace' backward-kill-word-match
)

# 搜索历史
function fz-history-widget() {
    local query="
SELECT commands.argv
FROM   history
    LEFT JOIN commands
        ON history.command_id = commands.rowid
    LEFT JOIN places
        ON history.place_id = places.rowid
GROUP BY commands.argv
ORDER BY places.dir != '${PWD//'/''}',
    commands.argv LIKE '${BUFFER//'/''}%' DESC,
    Count(*) DESC
"
    # 保证搜索的是全部历史
    # NOTE: 此处依赖 fzf-tab
    local selected=$(fc -rl 1 | ftb-tmux-popup -n "2.." --tiebreak=index --prompt="cmd> " ${BUFFER:+-q$BUFFER})
    if [[ "$selected" != "" ]] {
        zle vi-fetch-history -n $selected
    }
}
zle -N fz-history-widget
keybindings[C-r]=fz-history-widget

# 搜索文件
# 会将 * 或 ** 替换为搜索结果
# 前者表示搜索单层, 后者表示搜索子目录
function fz-find() {
    local selected dir cut
    cut=$(grep -oP '[^* ]+(?=\*{1,2}$)' <<< $BUFFER)
    eval "dir=${cut:-.}"
    if [[ $BUFFER == *"**"* ]] {
        selected=$(fd -H . $dir | ftb-tmux-popup --tiebreak=end,length --prompt="cd> ")
    } elif [[ $BUFFER == *"*"* ]] {
        selected=$(fd -d 1 . $dir | ftb-tmux-popup --tiebreak=end --prompt="cd> ")
    }
    BUFFER=${BUFFER/%'*'*/}
    BUFFER=${BUFFER/%$cut/$selected}
    zle end-of-line
}
zle -N fz-find
keybindings[M-s]=fz-find


# 快速跳转到指定字符
function zce-jump-char() {
    [[ -z $BUFFER ]] && zle up-history
    zstyle ':zce:*' keys 'asdghklqwertyuiopzxcvbnmfj;23456789'
    zstyle ':zce:*' prompt-char '%B%F{green}Jump to character:%F%b '
    zstyle ':zce:*' prompt-key '%B%F{green}Target key:%F%b '
    with-zce zce-raw zce-searchin-read
    CURSOR+=1
}
zle -N zce-jump-char
keybindings[M-j]=zce-jump-char

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
keybindings[.]=rationalise-dot

# 用编辑器编辑当前行
autoload -U edit-command-line
function edit-command-line-as-zsh {
    TMPSUFFIX=.zsh
    edit-command-line
    unset TMPSUFFIX
}
zle -N edit-command-line-as-zsh
keybindings+=('C-x C-e' edit-command-line-as-zsh)

# 棒棒 M-x
function execute-command() {
    local selected=$(printf "%s\n" ${(k)widgets} | ftb-tmux-popup --reverse --prompt="cmd> " --height=10 )
    zle redisplay
    [[ $selected ]] && zle $selected
}
zle -N execute-command
keybindings[M-x]=execute-command

ebindkey -A keybindings

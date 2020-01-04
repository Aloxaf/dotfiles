source ~/.zplugin/bin/zplugin.zsh

# 作为嵌入式终端时禁用 tmux
# https://www.reddit.com/r/tmux/comments/a2e5mn/tmux_on_dolphin_inbuilt_terminal/
# 上面的方法由于 alacritty 0.4.0 的释出而失效
if [[ "$TMUX" == "" && $- == *i* ]] {
    [[ "$(</proc/$PPID/cmdline)" =~ "/usr/bin/(dolphin|emacs|kate)" ]] || exec tmux
}

fpath+=("$HOME/.config/zsh/functions")

autoload -Uz rgzh rgsrc rgdata pslist ebindkey expand_alias palette
autoload +X zman

# ==== 加载 GitHub 插件 ====

zplugin light-mode lucid wait for \
    zdharma/fast-syntax-highlighting \
    skywind3000/z.lua

zplugin light-mode lucid wait for \
    atload='_zsh_autosuggest_start' \
        zsh-users/zsh-autosuggestions \
    blockf \
        zsh-users/zsh-completions \
    as="program" atclone="rm -f ^(rgg|agv)" \
        lilydjwg/search-and-view \
    atclone='sed -i "s/\^h/^?/" autopair.zsh' \
        hlissner/zsh-autopair

zplugin light hchbaw/zce.zsh
# zplugin light Aloxaf/fzf-tab

zplugin ice atclone="dircolors -b LS_COLORS > c.zsh" atpull='%atclone' pick="c.zsh"
zplugin light trapd00r/LS_COLORS

export AGV_EDITOR='kwrite -l $line -c $col $file'

# ==== 加载 OMZ 插件 ====

zplugin for \
    OMZ::lib/clipboard.zsh \
    OMZ::lib/git.zsh \
    OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh \
    OMZ::plugins/git-extras/git-extras.plugin.zsh \
    OMZ::plugins/systemd/systemd.plugin.zsh \
    OMZ::plugins/sudo/sudo.plugin.zsh

zplugin svn for \
    OMZ::plugins/extract \
    OMZ::plugins/pip

zplugin as="completion" for \
    OMZ::plugins/cargo/_cargo \
    OMZ::plugins/rust/_rust \
    OMZ::plugins/fd/_fd

zplugin ice lucid wait
zplugin snippet OMZ::plugins/git/git.plugin.zsh

# ==== 加载自定义插件 ====

CUSTOM=~/.config/zsh

source $CUSTOM/snippets/alias.zsh
source $CUSTOM/snippets/alias-tips.zsh
source $CUSTOM/snippets/completion.zsh
source $CUSTOM/snippets/history.zsh
source $CUSTOM/snippets/key-bindings.zsh
source $CUSTOM/snippets/misc.zsh

source ~/Coding/shell/fzf-tab/fzf-tab.zsh

zplugin ice as="completion"
zplugin snippet $CUSTOM/snippets/_bat

zplugin ice lucid wait atload="ZPLGM[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay"
zplugin snippet ~/.travis/travis.sh

# ==== 加载主题 ====

PROMPT=$'\n%F{cyan}❯ %f'
RPROMPT=""
zstyle ':prompt:pure:prompt:success' color cyan
zplugin ice lucid wait="!0" pick="async.zsh" src="pure.zsh" atload="prompt_pure_precmd"
zplugin light Aloxaf/pure

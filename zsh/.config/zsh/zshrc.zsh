source ~/.zplugin/bin/zplugin.zsh

# 作为嵌入式终端时禁用 tmux
# https://www.reddit.com/r/tmux/comments/a2e5mn/tmux_on_dolphin_inbuilt_terminal/
# 上面的方法由于 alacritty 0.4.0 的释出而失效
if [[ "$TMUX" == "" && $- == *i* ]] {
    [[ "$(</proc/$PPID/cmdline)" =~ "/usr/bin/(dolphin|emacs|kate)" ]] || exec tmux
}

fpath+=("$HOME/.config/zsh/functions")

autoload -Uz rgzh   rgsrc   rgdata  pslist
autoload +X zman

# ==== 加载 GitHub 插件 ====

zplugin ice lucid wait
zplugin light hlissner/zsh-autopair

zplugin ice lucid wait
zplugin light skywind3000/z.lua

zplugin ice lucid wait
zplugin light zdharma/fast-syntax-highlighting

zplugin ice lucid wait atload='_zsh_autosuggest_start'
zplugin light zsh-users/zsh-autosuggestions

zplugin ice blockf
zplugin light zsh-users/zsh-completions

zplugin light hchbaw/zce.zsh

zplugin ice as="program" atclone="rm install *.rst vv agg"
zplugin light lilydjwg/search-and-view
AGV_EDITOR='kwrite -l $line -c $col $file'

# ==== 加载 OMZ 插件 ====

zplugin snippet OMZ::lib/clipboard.zsh
zplugin snippet OMZ::lib/git.zsh
zplugin snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
zplugin snippet OMZ::plugins/sudo/sudo.plugin.zsh

zplugin ice lucid wait
zplugin snippet OMZ::plugins/git/git.plugin.zsh

zplugin ice svn; zplugin snippet OMZ::plugins/extract
zplugin ice svn; zplugin snippet OMZ::plugins/pip
zplugin ice as="completion"; zplugin snippet OMZ::plugins/cargo/_cargo
zplugin ice as="completion"; zplugin snippet OMZ::plugins/rust/_rust
zplugin ice as="completion"; zplugin snippet OMZ::plugins/fd/_fd

# ==== 加载自定义插件 ====

CUSTOM=~/.config/zsh

source $CUSTOM/snippets/alias.zsh
source $CUSTOM/snippets/alias-tips.zsh
# FIXME: 如果 completion 在 key-bindinds 之前初始化会有问题
source $CUSTOM/snippets/key-bindings.zsh
source $CUSTOM/snippets/completion.zsh
source $CUSTOM/snippets/history.zsh
source $CUSTOM/snippets/misc.zsh

zplugin ice lucid wait atload="zpcompinit; zpcdreplay"
zplugin snippet ~/.travis/travis.sh

# ==== 加载主题 ====

PROMPT=$'\n%F{cyan}❯ %f'
RPROMPT=""
zstyle ':prompt:pure:prompt:success' color cyan
zplugin ice lucid wait="!0" pick="async.zsh" src="pure.zsh" atload="prompt_pure_precmd"
zplugin light Aloxaf/pure

source ~/.zplugin/bin/zplugin.zsh

# https://superuser.com/questions/480928/is-there-any-command-like-time-but-for-memory-usage/767491
TIMEFMT=$'%J    user:%U system:%S cpu:%P total:%*E\nmax memory:	%M MB'

# rustup mirror
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

# speed up rustc compile
# removed because all cache has be placed in ~/.cache/cargo-build
# export RUSTC_WRAPPER=sccache

# Dolphin 下禁用 tmux 以便使用 z 快速跳转目录
# https://www.reddit.com/r/tmux/comments/a2e5mn/tmux_on_dolphin_inbuilt_terminal/
# 上面的方法由于 alacritty 0.4.0 的释出而失效
if [[ "$TMUX" == "" && $- == *i* ]] {
    [[ "$(</proc/$PPID/cmdline)" != *"/usr/bin/dolphin"* ]] && exec tmux
}

fpath+=("$HOME/.config/zsh/functions")

autoload -Uz rgzh   rgsrc   rgdata  pslist
autoload +X zman

# 避免 zpty z zsh -i 启动的 zsh 加载多余插件
if [[ "$(</proc/$$/cmdline)" != $'zsh\x00-i\x00' ]] {

# ==== 加载 GitHub 插件 ====

zplugin ice lucid wait='1'
zplugin light MichaelAquilina/zsh-you-should-use

zplugin ice lucid wait='1'
zplugin light hlissner/zsh-autopair

zplugin ice lucid wait='0'
zplugin light skywind3000/z.lua

zplugin ice lucid wait='0'
zplugin light zdharma/fast-syntax-highlighting

zplugin ice lucid wait='0' atload='_zsh_autosuggest_start'
zplugin light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1

zplugin ice blockf
zplugin light zsh-users/zsh-completions

# zplugin snippet https://mimosa-pudica.net/src/incr-0.2.zsh
# zplugin light hchbaw/auto-fu.zsh

zplugin light hchbaw/zce.zsh
bindkey "^Xj" zce

# ==== 加载 OMZ 插件 ====

zplugin ice lucid wait="0"
zplugin snippet OMZ::plugins/git/git.plugin.zsh

zplugin snippet OMZ::lib/clipboard.zsh
zplugin snippet OMZ::lib/completion.zsh
zplugin snippet OMZ::lib/key-bindings.zsh
zplugin snippet OMZ::lib/git.zsh
zplugin snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
zplugin snippet OMZ::plugins/sudo/sudo.plugin.zsh

zplugin ice svn; zplugin snippet OMZ::plugins/extract
zplugin ice as="completion"; zplugin snippet OMZ::plugins/cargo/_cargo
zplugin ice as="completion"; zplugin snippet OMZ::plugins/rust/_rust

# ==== 加载自定义插件 ====

CUSTOM=~/.config/zsh

zplugin snippet $CUSTOM/snippets/alias.zsh
zplugin snippet $CUSTOM/snippets/fuzzy.zsh
zplugin snippet $CUSTOM/snippets/history.zsh
zplugin snippet $CUSTOM/snippets/zce.zsh
zplugin snippet $CUSTOM/snippets/opts.zsh
zplugin snippet $CUSTOM/snippets/capture.zsh

zplugin ice lucid wait="0" atload="zpcompinit; zpcdreplay"
zplugin snippet ~/.travis/travis.sh

# ==== 加载主题 ====

PROMPT=$'\n%F{cyan}❯ %f'
RPROMPT=""
zstyle ':prompt:pure:prompt:success' color cyan
zplugin ice lucid wait="!0" pick="async.zsh" src="pure.zsh" atload="prompt_pure_precmd"
zplugin light Aloxaf/pure

} else {

CUSTOM=~/.config/zsh

zplugin ice blockf
zplugin light zsh-users/zsh-completions

zplugin snippet OMZ::plugins/git/git.plugin.zsh
zplugin snippet OMZ::lib/git.zsh
zplugin snippet $CUSTOM/snippets/alias.zsh

zplugin ice as="completion"; zplugin snippet OMZ::plugins/cargo/_cargo
zplugin ice as="completion"; zplugin snippet OMZ::plugins/rust/_rust

autoload -Uz compinit
compinit
zplugin cdreplay -q

}
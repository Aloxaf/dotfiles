# load zplugin module, use zpmod -h for help
module_path+=( "$HOME/.zplugin/bin/zmodules/Src" )
zmodload zdharma/zplugin

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

# ==== 加载 GitHub 插件 ====

zplg ice lucid wait='1'
zplg light MichaelAquilina/zsh-you-should-use

zplg ice lucid wait='1'
zplg light hlissner/zsh-autopair

zplg ice lucid wait='0'
zplg light skywind3000/z.lua

zplg ice lucid wait='0' atinit='zpcompinit'
zplg light zdharma/fast-syntax-highlighting

zplg ice wait lucid atload='_zsh_autosuggest_start'
zplg light zsh-users/zsh-autosuggestions

zplg ice lucid wait='0'
zplg light zsh-users/zsh-completions

zplg light hchbaw/zce.zsh
bindkey "^Xj" zce

# ==== 加载 OMZ 插件 ====

zplg ice svn
zplg snippet OMZ::plugins/extract

zplg ice lucid wait='0'
zplg snippet OMZ::plugins/git/git.plugin.zsh

zplg snippet OMZ::lib/clipboard.zsh
zplg snippet OMZ::lib/completion.zsh
zplg snippet OMZ::lib/history.zsh
zplg snippet OMZ::lib/key-bindings.zsh
zplg snippet OMZ::lib/git.zsh
zplg snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
zplg snippet OMZ::plugins/sudo/sudo.plugin.zsh

zplg ice as"completion"; zplg snippet OMZ::plugins/cargo/_cargo
zplg ice as"completion"; zplg snippet OMZ::plugins/rust/_rust

# ==== 加载自定义插件 ====

CUSTOM=~/.config/zsh

zplg snippet $CUSTOM/snippets/alias.zsh
zplg snippet $CUSTOM/snippets/fuzzy.zsh
zplg snippet $CUSTOM/snippets/rgcdda.zsh
zplg snippet $CUSTOM/snippets/zce.zsh
zplg snippet $CUSTOM/snippets/opts.zsh

zplg ice lucid wait="1"
zplg snippet /home/aloxaf/.travis/travis.sh

# ==== 加载主题 ====

zstyle ':prompt:pure:prompt:success' color cyan
zplg ice pick"async.zsh" src"pure.zsh"
zplg light Aloxaf/pure

# load zplugin module, use zpmod -h for help
module_path+=( "$HOME/.zplugin/bin/zmodules/Src" )
zmodload zdharma/zplugin

source ~/.zplugin/bin/zplugin.zsh

# `time` will show max memotry
# https://superuser.com/questions/480928/is-there-any-command-like-time-but-for-memory-usage/767491
TIMEFMT='%J    user:%U system:%S cpu:%P total:%*E'$'\nmax memory:	%M MB'

# rustup mirror
export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

# speed up rustc compile
# removed because all cache has be placed in ~/.cache/cargo-build
# export RUSTC_WRAPPER=sccache

# no tmux in Dolphin so that I can change directory quickly
# https://www.reddit.com/r/tmux/comments/a2e5mn/tmux_on_dolphin_inbuilt_terminal/
windowname=$(xdotool getactivewindow getwindowname)
if [[ "$windowname" != *"Dolphin"* ]] ;then
   [[ $- != *i* ]] && return 0
   [[ -z "$TMUX" ]] && exec tmux
fi

# added by travis gem
[ -f /home/aloxaf/.travis/travis.sh ] && source /home/aloxaf/.travis/travis.sh

# for better oh-my-zsh experience

DISABLE_LS_COLORS=true


zplg ice lucid wait='!0'
zplugin light paulirish/git-open

zplg ice lucid wait='!0'
zplugin light skywind3000/z.lua

zplg ice lucid wait='!0' atinit='zpcompinit'
zplugin light zdharma/fast-syntax-highlighting

zplugin ice wait lucid atload='_zsh_autosuggest_start'
zplugin light zsh-users/zsh-autosuggestions

zplg ice lucid wait='!0'
zplugin light zsh-users/zsh-completions

zplugin ice wait="2" lucid as="program" pick="bin/git-dsf"
zplugin light zdharma/zsh-diff-so-fancy

zplugin ice svn
zplugin snippet OMZ::plugins/extract
zplugin snippet OMZ::lib/completion.zsh
zplugin snippet OMZ::lib/history.zsh
zplugin snippet OMZ::lib/key-bindings.zsh
zplugin snippet OMZ::lib/theme-and-appearance.zsh
zplugin snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
zplugin snippet OMZ::plugins/sudo/sudo.plugin.zsh

zplg ice lucid wait='!0'
zplugin snippet OMZ::plugins/git/git.plugin.zsh

CUSTOM=~/.config/zsh/custom

zplugin snippet $CUSTOM/themes/loli.zsh-theme
zplugin snippet $CUSTOM/plugins/alias.plugin.zsh
zplugin snippet $CUSTOM/plugins/fuzzy.plugin.zsh
zplugin snippet $CUSTOM/plugins/rgcdda.plugin.zsh

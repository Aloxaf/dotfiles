# for better oh-my-zsh experience
DISABLE_MAGIC_FUNCTIONS=true
DISABLE_AUTO_UPDATE=true
ZSH_DISABLE_COMPFIX=true
ZSH="$HOME/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"

# init my plugins
source ~/.config/zsh/plugins.zsh

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

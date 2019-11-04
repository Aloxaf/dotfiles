# Init antigen
ANTIGEN_PATH=~/dotfiles/zsh
DISABLE_MAGIC_FUNCTIONS=true
fpath+=($ANTIGEN_PATH/.antigen/bundles/robbyrussell/oh-my-zsh/custom/completions $fpath)
source $ANTIGEN_PATH/.antigen/antigen.zsh
antigen init ~/.antigenrc

ZSH_PIP_INDEXES=(https://mirrors.ustc.edu.cn/pypi/web/simple/)

# https://superuser.com/questions/480928/is-there-any-command-like-time-but-for-memory-usage/767491
TIMEFMT='%J   %U  user %S system %P cpu %*E total'$'\n'\
'max memory:	%M MB'

# rustup
export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup
# export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
# speed up rustc compile
# removed: all cache will be placed in ~/.cache/cargo-build
# export RUSTC_WRAPPER=sccache

export _ZL_MATCH_MODE=1

# https://www.reddit.com/r/tmux/comments/a2e5mn/tmux_on_dolphin_inbuilt_terminal/
windowname=$(xdotool getactivewindow getwindowname) # find window title
if [[ "$windowname" != *"Dolphin"* ]] ;then # determine if window is not Dolphin
   [[ $- != *i* ]] && return 0
   [[ -z "$TMUX" ]] && exec tmux
fi

function rgzh() {
    str=$1
    shift
    rg "$str" ~/Coding/C++/Cataclysm-DDA/lang/po/zh_CN.po "$@"
}

function rgsrc() {
    str=$1
    shift
    rg "$str" ~/Coding/C++/Cataclysm-DDA/src -I -N "$@" | bat --language=C++
}

function rgdata() {
    str=$1
    shift
    rg "$str" ~/Coding/C++/Cataclysm-DDA/data -I -N "$@" | bat --language=json
}

# added by travis gem
[ -f /home/aloxaf/.travis/travis.sh ] && source /home/aloxaf/.travis/travis.sh

# eval "$(starship init zsh)"

# Init antigen
ANTIGEN_PATH=~/dotfiles/zsh
DISABLE_MAGIC_FUNCTIONS=true
fpath=($ANTIGEN_PATH/.antigen/bundles/robbyrussell/oh-my-zsh/custom/completions $fpath)
source $ANTIGEN_PATH/.antigen/antigen.zsh
antigen init ~/.antigenrc

ZSH_PIP_INDEXES=(https://mirrors.ustc.edu.cn/pypi/web/simple/)

# Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND='fd --type f'
# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# Set preview
export FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
# Use `` as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='``'


alias h="tldr"
alias ec="emacsclient -n -c -a ''"
#alias ecc="bindkey -v && emacsclient -nw -c -a '' && bindkey -e"
alias ecc="emacsclient -nw -c -a ''"
alias p="proxychains -q -f ~/.config/proxychains/8877.conf"
alias p8080="proxychains -q -f ~/.config/proxychains/8080.conf"
alias checksec="checksec --file"
alias amd="env DRI_PRIME=1"
alias trid="LC_ALL=C trid"
alias c='tput reset'
alias del='trash'
alias yafu='rlwrap yafu'
alias nc='rlwrap nc'
alias ls='exa --git'
alias la='ls -la'
alias lt='ls --tree'
alias zz='z -c'
alias zi='z -i'
alias zf='z -I'
alias zb='z -b'

export EDITOR="vim"

# for pacman
alias S='sudo pacman -S'
alias Syu='sudo pacman -Syu'
alias Ss='pacman -Ss'
alias Si='pacman -Si'
alias Qi='pacman -Qi'
alias Qs='pacman -Qs'
alias Ql='pacman -Ql'
alias Rns='sudo pacman -Rns'
alias Fs='pacman -Fs'
alias Fy='sudo pacman -Fy'
alias U='sudo pacman -U'

alias gdb-peda='gdb -q -ex init-peda'
alias gdb-pwndbg='gdb -q -ex init-pwndbg'
alias gdb-gef='gdb -q -ex init-gef'
alias gdb=gdb-pwndbg

alias blogin='/home/aloxaf/Coding/日常脚本/bit_login.py login'
alias blogout='/home/aloxaf/Coding/日常脚本/bit_login.py logout'
# alias yay='ALL_PROXY=socks5://127.0.0.1:1080 yay'
# alias yay='yay --aururl https://aur.tuna.tsinghua.edu.cn/'
alias wtf='wtf -f /home/aloxaf/.local/share/wtf/acronyms'

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

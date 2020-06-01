# global alias
alias -g H='| head ' T='| tail ' L='| less ' R='| rgc '
alias -g S='| sort ' U='| uniq '
alias -g N='>/dev/null '
# https://roylez.info/2010-03-06-zsh-recent-file-alias/
alias -g NN="*(oc[1])" NNF="*(oc[1].)" NND="*(oc[1]/)"

# 文件系统相关
alias rm='rm -i'   rd='rmdir'   md='mkdir -p'
alias ls='exa -h'  la='ls -la'  lt='ls --tree'  ll='ls -l'  l='ls'
alias dfh='df -h'  dus='du -sh' del='gio trash' dusa='dus --apparent-size'

# gdb
alias gdb-peda='command gdb -q -ex init-peda'
alias gdb-pwndbg='command gdb -q -ex init-pwndbg'
alias gdb-gef='command gdb -q -ex init-gef'
alias gdb=gdb-pwndbg

# pacman
alias S='sudo pacman -S' Syu='sudo pacman -Syu' Rcs='sudo pacman -Rcs'
alias Si='pacman -Si' Sl='pacman -Sl'  Ss='pacman -Ss'
alias Qi='pacman -Qi' Qs='pacman -Qs'  Ql='pacman -Ql'
alias Qo='pacman -Qo' Fy='pacman -Fy'  F='pacman -F'
alias Fx='pacman -Fx' Fy='sudo pacman -Fy'  U='sudo pacman -U'
alias pacman='noglob pacman'

alias zmv='noglob zmv'
alias zcp='zmv -C'
alias zln='zmv -L'

# wrapper 的 wrapper
# 用于处理被 wrap 的命令是 alias 的情况
function _wwrapper() {
    local -a wrapper=(${(z)1}) cmd
    expand_alias cmd ${(z)2}
    if (( ! $+commands[$cmd[1]] )) && [[ ! -f $cmd[1] ]] {
        print -P "%F{red}%B$cmd[1] is not an executable file%b%f" && return
    }
    $wrapper ${(e)cmd} $argv[3,-1]
}
compdef _precommand _wwrapper

# 写成函数方便定义补全
function proxychains_8877() {
    proxychains -q -f ~/.config/proxychains/8877.conf $@
}
function proxychains_8080() {
    proxychains -q -f ~/.config/proxychains/8080.conf $@
}
compdef _precommand proxychains_8877
compdef _precommand proxychains_8080

# wrapper
alias p="_wwrapper proxychains_8877"
alias p8080="_wwrapper proxychains_8080"
alias rlwrap="_wwrapper rlwrap"

# 乱七八糟的
alias h="tldr"
alias ec="emacsclient -n -c -a ''"
alias ecc="emacsclient -nw -c -a ''"
alias checksec="checksec --file"
alias amd="env DRI_PRIME=1"
alias trid="LC_ALL=C trid"
alias yafu='command rlwrap yafu'
alias nc='command rlwrap nc'
alias blogin="bit_login login"
alias blogout="bit_login logout"
alias wtf='wtf -f ~/.local/share/wtf/acronyms'
alias rgc='rg --color=always'
alias less='less -r'
alias history='fc -l 1'
alias locate='noglob locate'

function dsf() {
    diff -u $@ | delta --theme='Dracula'
}

# 从爱呼吸老师那里抄的
# https://github.com/farseerfc/dotfiles/blob/master/zsh/.bashrc#L100-L123
function G() {
    git clone https://git.archlinux.org/svntogit/$1.git/ -b packages/$3 --single-branch $3
    mv "$3"/trunk/* "$3"
    rm -rf "$3"/{repos,trunk,.git}
}

function Ge() {
    [ -z "$@" ] && echo "usage: $0 <core/extra package name>: get core/extra package PKGBUILD" && return 1
    for i in $@; do
    	G packages core/extra $i
    done
}

function Gc() {
    [ -z "$@" ] && echo "usage: $0 <community package name>: get community package PKGBUILD" && return 1
    for i in $@; do
    	G community community $i
    done
}


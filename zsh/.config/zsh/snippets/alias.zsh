# global alias
alias -g H='| head ' T='| tail ' L='| less ' R='| rgc '
alias -g S='| sort ' U='| uniq '
alias -g N='>/dev/null '
# https://roylez.info/2010-03-06-zsh-recent-file-alias/
alias -g NN="*(oc[1])" NNF="*(oc[1].)" NND="*(oc[1]/)"

# 文件系统相关
alias rd='rm -rd'   md='mkdir -p'
alias rm='rm -i --one-file-system'
alias ls='exa -bh' la='ls -la'  lt='ls --tree'  ll='ls -l'  l='ls'
alias dfh='df -h'  dus='du -sh' del='gio trash' dusa='dus --apparent-size'
alias cp='cp --reflink=auto'
alias bdu='btrfs fi du' bdus='bdu -s'

# gdb
alias gdb-peda='command gdb -q -ex init-peda'
alias gdb-pwndbg='command gdb -q -ex init-pwndbg'
alias gdb-gef='command gdb -q -ex init-gef'
alias gdb=gdb-pwndbg

# pacman
alias S='sudo pacman -S' Syu='sudo pacsync && sudo pacman -Su' Rcs='sudo pacman -Rcs'
alias Si='pacman -Si' Sl='pacman -Sl' Ss='noglob pacman -Ss'
alias Qi='pacman -Qi' Ql='pacman -Ql' Qs='noglob pacman -Qs'
alias Qm='pacman -Qm' Qo='pacman -Qo'
alias Fl='pacman -Fl' F='pacman -F' Fx='pacman -Fx'
alias Fy='sudo pacman -Fy'
alias U='sudo pacman -U'
alias pikaur='p pikaur'

# git
# https://github.blog/2020-12-21-get-up-to-speed-with-partial-clone-and-shallow-clone/
alias gclt='git clone --filter=tree:0'
alias gclb='git clone --filter=blob:none'
alias gcld='git clone --depth=1'

function Qlt() {
  pacman -Ql $1 | cut -d' ' -f2 | tree --fromfile=.
}

function compsize-package {
  sudo compsize $(pacman -Ql $1 | cut -d' ' -f2 | grep -v '/$')
}

function _pacman_packages {
  (( $+functions[_pacman_completions_installed_packages] )) || {
    _pacman 2>/dev/null
  }
  _pacman_completions_installed_packages
}

compdef _pacman_packages Qlt compsize-package

alias zmv='noglob zmv'
alias zcp='zmv -C'
alias zln='zmv -L'

# 写成函数方便定义补全
function proxychains_8877() {
    proxychains -q -f ~/.config/proxychains/8877.conf $@
}
function proxychains_8080() {
    proxychains -q -f ~/.config/proxychains/8080.conf $@
}
function pp() {
    # aria2 只吃 http[s]_proxy 并且只支持 http
    #env HTTP_PROXY="socks5h://127.0.0.1:8877" \
    #    HTTPS_PROXY="socks5h://127.0.0.1:8877" \
    #    http_proxy="http://127.0.0.1:1080" \
    #    https_proxy="http://127.0.0.1:1080" $*
    env HTTP_PROXY="http://127.0.0.1:1080" \
        HTTPS_PROXY="http://127.0.0.1:1080" \
        http_proxy="http://127.0.0.1:1080" \
        https_proxy="http://127.0.0.1:1080" $*
}
compdef _precommand proxychains_8877
compdef _precommand proxychains_8080

# wrapper
alias p="proxychains_8877 "
alias p8080="proxychains_8080 "
alias rlwrap="rlwrap "
alias sudo='sudo '

# 乱七八糟的
alias h="tldr"
alias ec="emacsclient -n -c -a ''"
alias ecc="emacsclient -nw -c -a ''"
alias checksec="pwn checksec"
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
alias open='xdg-open'
alias cataclysm-tiles='LANGUAGE=zh_CN:en_US cataclysm-tiles'
alias locate="lolcate"
alias wine32="WINEPREFIX=~/.wine32 WINEARCH=win32 wine"
alias wine32cfg="WINEPREFIX=~/.wine32 WINEARCH=win32 winecfg"
alias wine32tricks="WINEPREFIX=~/.wine32 WINEARCH=win32 winetricks"

function dsf() {
    diff -u $@ | delta --theme='Dracula'
}

# 从爱呼吸老师那里抄的
# https://github.com/farseerfc/dotfiles/blob/master/zsh/.bashrc#L100-L123
function G() {
    git clone https://git.archlinux.org/svntogit/$1.git/ -b packages/$3 --single-branch $3
    #mv "$3"/trunk/* "$3"
    #rm -rf "$3"/{repos,trunk,.git}
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


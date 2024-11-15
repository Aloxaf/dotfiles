# global alias
alias -g H='| head ' T='| tail ' L='| less ' R='| rgc '
alias -g S='| sort ' U='| uniq '
alias -g N='>/dev/null '
# https://roylez.info/2010-03-06-zsh-recent-file-alias/
alias -g NN="*(oc[1])" NNF="*(oc[1].)" NND="*(oc[1]/)"

# 文件系统相关
alias rd='rm -rd'   md='mkdir -p'
alias rm='rm -i --one-file-system'
alias ls='eza -bh' la='ls -la'  lt='ls --tree'  ll='ls -l'  l='ls'
alias dfh='df -h'  dus='du -sh' del='gio trash' dusa='dus --apparent-size'
alias cp='cp --reflink=auto'
alias bdu='btrfs fi du' bdus='bdu -s'

# gdb
alias gdb-peda='command gdb -q -ex init-peda'
alias gdb-pwndbg='command gdb -q -ex init-pwndbg'
alias gdb-gef='command gdb -q -ex init-gef'
alias gdb=gdb-pwndbg

# pacman
alias S='sudo pacman -S' Syu='sudo pacman -Syu' Rcs='sudo pacman -Rcs'
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

function pp() {
    # aria2 只吃 http[s]_proxy 并且只支持 http
    env HTTP_PROXY="http://127.0.0.1:8877" \
        HTTPS_PROXY="http://127.0.0.1:8877" \
        http_proxy="http://127.0.0.1:8877" \
        https_proxy="http://127.0.0.1:8877" $*
}

# wrapper
alias rlwrap="rlwrap "
alias sudo='sudo '

# 乱七八糟的
alias http=xh
alias h="tldr"
alias checksec="pwn checksec"
alias amd="env DRI_PRIME=1"
alias trid="LC_ALL=C trid"
alias wtf='wtf -f ~/.local/share/wtf/acronyms'
alias rgc='rg --color=always'
alias less='less -r'
alias history='fc -l 1'
alias open='xdg-open'

function dsf() {
    diff -u $@ | delta
}

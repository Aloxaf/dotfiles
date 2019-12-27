# systemctl
alias userctl='systemctl --user'  userstp='userctl stop'   userrst='userctl restart'
alias systemctl='sudo systemctl'  sysstp='systemctl stop'  sysrst='systemctl restart'

# 文件系统相关
alias rm='rm -i'   rd='rmdir'   md='mkdir -p'
alias ls='exa -h'  la='ls -la'  lt='ls --tree'  ll='ls -l'  l='ls'
alias df='df -h'   dus='du -sh' del='gio trash'
alias -g NUL='/dev/null'

# gdb
alias gdb-peda='gdb -q -ex init-peda' gdb-pwndbg='gdb -q -ex init-pwndbg'
alias gdb-gef='gdb -q -ex init-gef'   gdb=gdb-pwndbg

# pacman
alias S='sudo pacman -S'    Syu='sudo pacman -Syu'  Ss='pacman -Ss'
alias Si='pacman -Si'       Qi='pacman -Qi'         Qs='pacman -Qs'
alias Ql='pacman -Ql'       Rns='sudo pacman -Rns'  Fx='pacman -Fx'
alias Fy='sudo pacman -Fy'  U='sudo pacman -U'

# wrapper 的 wrapper
# 用于处理被 wrap 的命令是 alias 的情况
function _wwrapper() {
    local -a wrapper=(${(z)1}) command=(${(z)2})
    [[ -n $aliases[$2] ]] && command=(${(z)aliases[$2]})
    if [[ -z $commands[$command[1]] ]] {
        print -P "%F{red}%B$command[1] is not an executable file%b%f" && return
    }
    shift 2
    $wrapper $command "$@"
}

# wrapper
alias p="_wwrapper 'proxychains -q -f ~/.config/proxychains/8877.conf'"
alias p8080="_wwrapper 'proxychains -q -f ~/.config/proxychains/8080.conf'"
alias rlwrap="_wwrapper rlwrap"

# 乱七八糟的
alias h="tldr"
alias ec="emacsclient -n -c -a ''"
alias ecc="emacsclient -nw -c -a ''"
alias checksec="checksec --file"
alias amd="env DRI_PRIME=1"
alias trid="LC_ALL=C trid"
alias yafu='rlwrap yafu'
alias nc='rlwrap nc'
alias blogin="bit_login login"
alias blogout="bit_login logout"
alias wtf='wtf -f ~/.local/share/wtf/acronyms'
alias rgc='rg --color=always'
alias less='less -r'

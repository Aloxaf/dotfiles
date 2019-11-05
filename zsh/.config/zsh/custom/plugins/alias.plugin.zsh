
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

alias gdb-peda='gdb -q -ex init-peda'
alias gdb-pwndbg='gdb -q -ex init-pwndbg'
alias gdb-gef='gdb -q -ex init-gef'
alias gdb=gdb-pwndbg

alias blogin='/home/aloxaf/Coding/日常脚本/bit_login.py login'
alias blogout='/home/aloxaf/Coding/日常脚本/bit_login.py logout'
# alias yay='ALL_PROXY=socks5://127.0.0.1:1080 yay'
# alias yay='yay --aururl https://aur.tuna.tsinghua.edu.cn/'
alias wtf='wtf -f /home/aloxaf/.local/share/wtf/acronyms'

# for pacman
alias S='sudo pacman -S'
alias Syu='sudo pacman -Syu'
alias Ss='pacman -Ss'
alias Si='pacman -Si'
alias Qi='pacman -Qi'
alias Qs='pacman -Qs'
alias Ql='pacman -Ql'
alias Rns='sudo pacman -Rns'
alias Fx='pacman -Fx'
alias Fy='sudo pacman -Fy'
alias U='sudo pacman -U'

alias userctl='systemctl --user'

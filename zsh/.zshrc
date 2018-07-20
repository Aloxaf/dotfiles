ANTIGEN_PATH=~/dotfiles/zsh
source $ANTIGEN_PATH/.antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle httpie
antigen bundle sudo
antigen bundle extract
antigen bundle colored-man-pages

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions

# Load the theme.
antigen bundle /home/aloxaf/dotfiles/zsh/.oh-my-zsh/custom/themes loli.zsh-theme  --no-local-clone


# Tell Antigen that you're done.
antigen apply

ZSH_PIP_INDEXES=(https://mirrors.ustc.edu.cn/pypi/web/simple/)

alias h="tldr"
alias ec="emacsclient -n -c -a ''"
alias p="proxychains -q -f ~/.config/proxychains/8877.conf"
alias p8080="proxychains -q -f ~/.config/proxychains/8080.conf"
alias cat="ccat"
# alias pwsh="TERM=xterm pwsh"
alias checksec="checksec --file"
alias amd="env DRI_PRIME=1"
# alias bro="2>/dev/null bro"
alias trid="LC_ALL=C trid"
alias c='tput reset'
alias del='trash'

EDITOR="emacsclient -n -c -a ''"

[[ $- != *i* ]] && return 0
[[ -z "$TMUX" ]] && exec tmux

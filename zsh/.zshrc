ANTIGEN_PATH=~/dotfiles/zsh
fpath=($ANTIGEN_PATH/.antigen/bundles/robbyrussell/oh-my-zsh/custom/completions $fpath)

source $ANTIGEN_PATH/.antigen/antigen.zsh

antigen init ~/.antigenrc

ZSH_PIP_INDEXES=(https://mirrors.ustc.edu.cn/pypi/web/simple/)

function init_fzf() {
    source /usr/share/fzf/completion.zsh
    source /usr/share/fzf/key-bindings.zsh

    # Setting fd as the default source for fzf
    export FZF_DEFAULT_COMMAND='fd --type f'
    # To apply the command to CTRL-T as well
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    # Set preview
    export FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
    # Use ~~ as the trigger sequence instead of the default **
    export FZF_COMPLETION_TRIGGER='~~'
}

init_fzf

alias h="tldr"
alias ec="emacsclient -n -c -a ''"
#alias ecc="bindkey -v && emacsclient -nw -c -a '' && bindkey -e"
alias ecc="emacsclient -nw -c -a ''"
alias p="proxychains -q -f ~/.config/proxychains/8877.conf"
alias p8080="proxychains -q -f ~/.config/proxychains/8080.conf"
# alias cat="ccat"
# alias cat="bat"
# alias pwsh="TERM=xterm pwsh"
alias checksec="checksec --file"
alias amd="env DRI_PRIME=1"
# alias bro="2>/dev/null bro"
alias trid="LC_ALL=C trid"
alias c='tput reset'
alias del='trash'
alias yafu='rlwrap yafu'
alias nc='rlwrap nc'
alias ll='exa -l'
alias la='exa -la'
alias ls='exa --git'

export EDITOR="emacsclient -nw -c -a ''"
# export EDITOR="vim"

# rustup
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

# speed up rustc compile
export RUSTC_WRAPPER=sccache

# [[ $- != *i* ]] && return 0
# [[ -z "$TMUX" ]] && exec tmux

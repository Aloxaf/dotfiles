export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export LANGUAGE=en_US # :zh_CN

export SSH_AUTH_SOCK=${SSH_AUTH_SOCK:-"$(gpgconf --list-dirs agent-ssh-socket)"}

ZDOTDIR=$XDG_CONFIG_HOME/zsh

path+=(
  ~/.local/bin
  ~/go/bin
  ~/.cargo/bin
  ~/.pub-cache/bin
)
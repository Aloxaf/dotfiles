typeset -A ZPLGM=(
    BIN_DIR  $XDG_DATA_HOME/zsh/zplugin/bin
    HOME_DIR $XDG_DATA_HOME/zsh/zplugin
)

module_path+=( "$XDG_DATA_HOME/zsh/zplugin/bin/zmodules/Src" )
zmodload zdharma/zplugin

source $XDG_CONFIG_HOME/zsh/zshrc.zsh

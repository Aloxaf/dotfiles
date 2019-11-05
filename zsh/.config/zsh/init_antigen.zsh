#!/usr/bin/zsh

CUSTOM=~/.config/zsh/custom

antibody bundle <<EOF > ./plugins.zsh
robbyrussell/oh-my-zsh
robbyrussell/oh-my-zsh path:plugins/extract
robbyrussell/oh-my-zsh path:plugins/git
robbyrussell/oh-my-zsh path:plugins/sudo

paulirish/git-open
skywind3000/z.lua
zdharma/fast-syntax-highlighting
zsh-users/zsh-autosuggestions
zsh-users/zsh-completions

$CUSTOM/themes/loli.zsh-theme
$CUSTOM/plugins
EOF

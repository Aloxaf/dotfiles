#!/usr/bin/zsh

setopt extended_glob no_nomatch

function deploy_to_root() {
  local -a file=($1/*(#q:t))
  [[ -d "/$file[1]" ]]
}

for i (^systemd(/)); do
  if [[ ${i:t} == emacs-private ]]; then
    for j in $i/.emacs.d/private/*; do
      ln -s ${j:A} ~/.emacs.d/private/${j:t}
    done
    continue
  fi
  echo -n "deploying $i"
  if { deploy_to_root $i }; then
    echo " to /"
    sudo stow "$i" --ignore=.directory --target=/
  else
    echo " to $HOME"
    stow "$i" --ignore=.directory --target=$HOME
  fi
done

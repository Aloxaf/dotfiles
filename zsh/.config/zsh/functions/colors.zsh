#!/usr/bin/zsh

colors16() {
  for bold in {0..1}; do
    for i in {30..38}; do
      for j in {40..48}; do
        print -n "\x1b[$bold;$i;${j}m $bold;$i;$j |\x1b[0m"
      done
      print
    done
    print
  done

  for bold in {0..1}; do

  done
}

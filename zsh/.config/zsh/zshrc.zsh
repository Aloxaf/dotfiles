# 如果是非 tmux 启动的交互式终端，考虑启动 tmux
if [[ ( ! "$(</proc/$PPID/cmdline)" =~ "tmux" ) && $- == *i* ]]; then
  # 非嵌入式终端，启动 tmux
  if [[ ! "$(</proc/$PPID/cmdline)" =~ "dolphin|emacs|kate|visual-studio-code|SCREEN|zsh|cursor|code" ]]; then
    exec tmux -f "$XDG_CONFIG_HOME/tmux/tmux.conf"
  # 非 SCREEN 窗口，unset 相关环境变量，避免被识别为 TMUX 环境
  elif [[ ! "$(</proc/$PPID/cmdline)" =~ "SCREEN" ]]; then
    unset TMUX TMUX_PANE
  fi
fi

# zsh 正常启动后，立即加载 instant prompt
if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 初始化 zinit
typeset -A ZINIT=(
  BIN_DIR         $ZDOTDIR/zinit/bin
  HOME_DIR        $ZDOTDIR/zinit
  COMPINIT_OPTS   -C
)
source $ZDOTDIR/zinit/bin/zinit.zsh

# 加载插件

# 普通的延迟加载插件
zinit wait="0" lucid light-mode for \
  hlissner/zsh-autopair \
  hchbaw/zce.zsh \
  atinit="GENCOMP_DIR=$ZDOTDIR/completions" \
    Aloxaf/gencomp \

# zsh-z 首次加载在 HDD 上较慢，所以提前调用一次
zinit ice wait="0" lucid atload="zshz >/dev/null" atinit="ZSHZ_DATA=$ZDOTDIR/.z"
zinit light agkozak/zsh-z

# 一些需要特殊参数的插件
zinit light-mode for \
  blockf \
    zsh-users/zsh-completions \
  atclone="dircolors -b LS_COLORS > c.zsh" atpull='%atclone' pick='c.zsh' \
    trapd00r/LS_COLORS \
  src="etc/git-extras-completion.zsh" \
    tj/git-extras

# OMZ 里的不错玩意儿
zinit wait="1" lucid for \
  OMZL::clipboard.zsh \
  OMZL::git.zsh \
  OMZP::systemd/systemd.plugin.zsh \
  OMZP::sudo/sudo.plugin.zsh \
  OMZP::git/git.plugin.zsh \
  OMZP::ansible/ansible.plugin.zsh
zinit svn for \
  OMZP::extract
zinit as="completion" for \
  OMZP::rust/_rustc

# 其他本地插件
zinit ice wait="0" lucid
zinit snippet /usr/share/nvm/init-nvm.sh
zinit snippet /etc/grc.zsh

# 加载下面的插件之前，先加载补全
zpcompinit; zpcdreplay

# 自己的小脚本
# 自己的那堆玩意儿
fpath+=($ZDOTDIR/functions $ZDOTDIR/completions)
autoload -Uz $ZDOTDIR/functions/*(:t)
autoload +X zman
autoload -Uz zcalc zmv zargs
for i in $ZDOTDIR/snippets/*.zsh; do
  source $i
done
for i in $ZDOTDIR/plugins/*/*.plugin.zsh; do
  source $i
done

# 最好不延迟加载，免得出问题
# 同时由于这些插件包裹了 zle，需要放在最后加载
zinit light-mode for \
  Aloxaf/zsh-sqlite \
  Aloxaf/fzf-tab \
  zdharma/fast-syntax-highlighting \
  zsh-users/zsh-autosuggestions

# 加载主题
source $ZDOTDIR/p10k.zsh
zinit ice depth=1
zinit light romkatv/powerlevel10k

# 配置 zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY+=(match_prev_cmd completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_COMPLETION_IGNORE='( |man |pikaur -S )*'
# 太长的行不用触发建议
ZSH_AUTOSUGGEST_HISTORY_IGNORE='?(#c80,)'

# 更换 zce.zsh 使用的按键序列
zstyle ':zce:*' keys 'asdghklqwertyuiopzxcvbnmfj;23456789'

# 配置 fzf-tab
zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'
zstyle ':fzf-tab:complete:kill:*' popup-pad 0 3
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0
zstyle ":fzf-tab:*" fzf-flags --color=bg+:23
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' switch-group '<' '>'

FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}alias]='fg=blue'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}function]='fg=cyan'
# 对 man 的高亮会卡住上下翻历史的动作
# FAST_HIGHLIGHT[chroma-man]=


export LANGUAGE=en_US # :zh_CN

# 作为嵌入式终端时禁用 tmux
if [[ -z $TMUX && $- == *i* ]]; then
    if [[ ! "$(</proc/$PPID/cmdline)" =~ "/usr/bin/(dolphin|emacs|kate)|visual-studio-code" ]]; then
        exec tmux -f "$XDG_CONFIG_HOME/tmux/tmux.conf"
    fi
else
    # 如果当前 shell 是由 konsole 启动的，则 unset 相关变量
    # 免作为子进程的 konsole 继承相关变量导致 fzf-tab 误判为 tmux 环境
    if [[ "$(</proc/$PPID/cmdline)" =~ "konsole" ]]; then
        unset TMUX TMUX_PANE
    fi
fi

# 让 prompt 在底部
# printf "\n%.0s" {1..100}

# p10k instant prompt
# 可取代 zplugin turbo mode
if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==== Zplugin 初始化 ====

typeset -A ZINIT=(
    BIN_DIR         $ZDOTDIR/zinit/bin
    HOME_DIR        $ZDOTDIR/zinit
    COMPINIT_OPTS   -C
)

source $ZDOTDIR/zinit/bin/zinit.zsh

# ===== 函数 ====
PATH=$XDG_CONFIG_HOME/zsh/commands:$HOME/.emacs.d/bin/doom:$PATH
FPATH=$XDG_CONFIG_HOME/zsh/functions:$XDG_CONFIG_HOME/zsh/completions:$FPATH
# fpath+=("$XDG_CONFIG_HOME/zsh/functions" "$XDG_CONFIG_HOME/zsh/completions")

autoload -Uz $XDG_CONFIG_HOME/zsh/functions/*(:t)
autoload +X zman
autoload -Uz zcalc zmv zargs

# ==== 某些插件需要的设置 ====

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_COMPLETION_IGNORE='( |man |pikaur -S )*'

GENCOMP_DIR=$XDG_CONFIG_HOME/zsh/completions

forgit_add=gai
forgit_diff=gdi
forgit_log=glgi

ZSHZ_DATA=$ZDOTDIR/.z

export AGV_EDITOR='kwrite -l $line -c $col $file'

# ==== 加载插件 ====

zinit wait="1" lucid light-mode for \
    kevinhwang91/zsh-tmux-capture \
    hlissner/zsh-autopair \
    hchbaw/zce.zsh \
    Aloxaf/gencomp \
    agkozak/zsh-z \
    wfxr/forgit
    
zinit light-mode for \
    blockf \
        zsh-users/zsh-completions \
    as="program" atclone="rm -f ^(rgg|agv)" \
        lilydjwg/search-and-view \
    atclone="dircolors -b LS_COLORS > c.zsh" atpull='%atclone' pick='c.zsh' \
        trapd00r/LS_COLORS \
    src="etc/git-extras-completion.zsh" \
        tj/git-extras

# scfrazer/zsh-jump-target \
# zinit add-fpath scfrazer/zsh-jump-target functions
# agkozak/zsh-z \
# b4b4r07/enhancd \
# marlonrichert/zsh-autocomplete
# zinit light Aloxaf/fzf-tab

# export _ZL_DATA=$ZDOTDIR/.z
# skywind3000/z.lua

zinit wait="1" lucid for \
    OMZ::lib/clipboard.zsh \
    OMZ::lib/git.zsh \
    OMZ::plugins/systemd/systemd.plugin.zsh \
    OMZ::plugins/sudo/sudo.plugin.zsh \
    OMZ::plugins/git/git.plugin.zsh

zinit ice mv=":cht.sh -> cht.sh" atclone="chmod +x cht.sh" as="program"
zinit snippet https://cht.sh/:cht.sh

zinit ice mv=":zsh -> _cht" as="completion"
zinit snippet https://cheat.sh/:zsh

zinit svn for \
    OMZ::plugins/extract \
    OMZ::plugins/pip

zinit as="completion" for \
    OMZ::plugins/docker/_docker \
    OMZ::plugins/rust/_rust \
    OMZ::plugins/fd/_fd

source /etc/grc.zsh
source ~/.travis/travis.sh
source ~/Coding/shell/zvm/zvm.zsh

# ==== 某些比较特殊的插件 ====

zpcompinit; zpcdreplay

for i in $XDG_CONFIG_HOME/zsh/snippets/*.zsh; do
    source $i
done

for i in $XDG_CONFIG_HOME/zsh/plugins/*/*.plugin.zsh; do
    source $i
done

# ==== 加载并配置 fzf-tab ====

source ~/Coding/shell/fzf-tab/fzf-tab.zsh

zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'
zstyle ':fzf-tab:complete:kill:*' popup-pad 0 3
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:exa' file-sort modification
zstyle ':completion:*:exa' sort false
zstyle ":fzf-tab:*" fzf-flags --color=bg+:23
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# ==== ====

# https://blog.lilydjwg.me/2015/7/26/a-simple-zsh-module.116403.html
zmodload aloxaf/subreap
subreap

zinit light-mode for \
    zdharma/fast-syntax-highlighting \
    zsh-users/zsh-autosuggestions

# ==== 加载主题 ====

: ${THEME:=p10k}

case $THEME in
    pure)
        PROMPT=$'\n%F{cyan}❯ %f'
        RPROMPT=""
        zstyle ':prompt:pure:prompt:success' color cyan
        zinit ice lucid wait="!0" pick="async.zsh" src="pure.zsh" atload="prompt_pure_precmd"
        zinit light Aloxaf/pure
        ;;
    p10k)
        source $XDG_CONFIG_HOME/zsh/p10k.zsh
        zinit ice depth=1
        zinit light romkatv/powerlevel10k
        ;;
esac

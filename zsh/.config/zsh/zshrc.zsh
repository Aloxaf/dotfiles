# 作为非 tmux 启动的交互式终端，考虑启动 tmux
if [[ ( ! "$(</proc/$PPID/cmdline)" =~ "tmux" ) && $- == *i* ]]; then
    # 非嵌入式终端，启动 tmux
    if [[ ! "$(</proc/$PPID/cmdline)" =~ "dolphin|emacs|kate|visual-studio-code|SCREEN" ]]; then
        exec tmux -f "$XDG_CONFIG_HOME/tmux/tmux.conf"
    # 非 SCREEN 窗口，unset 相关环境变量，避免被识别为 TMUX 环境
    elif [[ ! "$(</proc/$PPID/cmdline)" =~ "SCREEN" ]]; then
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

HISTDB_FILE=$ZDOTDIR/.zsh-history.db
# return the latest used command in the current directory
_zsh_autosuggest_strategy_histdb_top_here() {
    (( $+functions[_histdb_query] )) || return
    (( $+builtins[zsqlite_exec] )) || return
    (( $+_HISTDB )) || zsqlite_open _HISTDB ${HISTDB_FILE}
    local reply reply_argv
    zsqlite_exec _HISTDB reply "
SELECT commands.argv
FROM   history
    LEFT JOIN commands
        ON history.command_id = commands.rowid
    LEFT JOIN places
        ON history.place_id = places.rowid
WHERE commands.argv LIKE '${1//'/''}%'
-- GROUP BY 会导致旧命令的新记录不生效
-- GROUP BY commands.argv
ORDER BY places.dir != '${PWD//'/''}',
    history.start_time DESC
LIMIT 1  
"
    typeset -g suggestion=$reply_argv
}

ZSH_AUTOSUGGEST_STRATEGY=(histdb_top_here match_prev_cmd completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_COMPLETION_IGNORE='( |man |pikaur -S )*'
ZSH_AUTOSUGGEST_HISTORY_IGNORE='?(#c50,)'

GENCOMP_DIR=$XDG_CONFIG_HOME/zsh/completions

forgit_add=gai
forgit_diff=gdi
forgit_log=glgi

ZSHZ_DATA=$ZDOTDIR/.z

export AGV_EDITOR='kwrite -l $line -c $col $file'

# for python-better-expections
export FORCE_COLOR=1

# ==== 加载插件 ====

zinit wait="0" lucid light-mode for \
    hlissner/zsh-autopair \
    hchbaw/zce.zsh \
    Aloxaf/gencomp \
    Aloxaf/zsh-sqlite \
    Aloxaf/zsh-histdb \
    wfxr/forgit

# the first call of zsh-z is slow in HDD, so call it in advance
zinit ice wait="0" lucid atload="zshz >/dev/null"
zinit light agkozak/zsh-z
    
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
    OMZL::clipboard.zsh \
    OMZL::git.zsh \
    OMZP::systemd/systemd.plugin.zsh \
    OMZP::sudo/sudo.plugin.zsh \
    OMZP::git/git.plugin.zsh

zinit ice mv=":cht.sh -> cht.sh" atclone="chmod +x cht.sh" as="program"
zinit snippet https://cht.sh/:cht.sh

zinit ice mv=":zsh -> _cht" as="completion"
zinit snippet https://cheat.sh/:zsh

zinit svn for \
    OMZP::extract \
    OMZP::pip

zinit as="completion" for \
    OMZP::docker/_docker \
    OMZP::rust/_rust \
    OMZP::fd/_fd

source /etc/grc.zsh
source ~/.travis/travis.sh
source ~/Coding/shell/zvm/zvm.zsh
source /opt/miniconda/etc/profile.d/conda.sh

zstyle ':zce:*' keys 'asdghklqwertyuiopzxcvbnmfj;23456789'

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
zstyle ":fzf-tab:*" fzf-flags --color=bg+:23
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:exa' sort false
zstyle ':completion:files' sort false
zstyle ':fzf-tab:*:*argument-rest*' popup-pad 100 0
# zstyle ':fzf-tab:*:*argument-rest*' fzf-preview '
# echo desc: $desc
# echo word: $word
# echo group: $group
# echo realpath: $realpath
# if [[ -z $realpath ]]; then
#   return
# fi
# # 用 exa 展示目录内容
# if [[ -d $realpath ]]; then
#   exa -1 --color=always $realpath
#   return
# fi
# local type=${$(file --mime-type $realpath)[(w)2]}
# case $type in;
#   text*) bat -p --color=always $realpath;;
# esac
# '

# ==== ====

# https://blog.lilydjwg.me/2015/7/26/a-simple-zsh-module.116403.html
zmodload aloxaf/subreap
subreap

set_fast_theme() {
    FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}alias]='fg=blue'
    FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}function]='fg=blue'
    # 对 man 的高亮会卡住上下翻历史的动作
    # FAST_HIGHLIGHT[chroma-man]=
}

zinit light-mode for \
    atload="set_fast_theme" \
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

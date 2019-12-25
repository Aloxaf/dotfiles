# 禁用旧补全系统
zstyle ':completion:*' use-compctl false
# 缓存补全结果
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR
# 方便选择
zstyle ':completion:*:*:*:*:*' menu select
# 大小写修正
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
# 不分组
zstyle ':completion:*' list-grouped false
# 无列表分隔符
zstyle ':completion:*' list-separator ''
# 补全当前用户所有进程列表
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
# complete manual by their section, from grml
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
# complete user-commands for git-*
# https://pbrisbin.com/posts/deleting_git_tags_with_style/
zstyle ':completion:*:*:git:*' user-commands ${${(M)${(k)commands}:#git-*}/git-/}
# zwc 什么的忽略掉吧
zstyle ':completion:*:*:*:*' file-patterns '^*.zwc'
zstyle ':completion:*:*:rm:*' file-patterns '*'
zstyle ':completion:*:*:gio:*' file-patterns '*'
# 好看的警告(与 fuzzy-complete 冲突)
# zstyle ':completion:*:warnings' format '%F{red}%BNo matches for: %F{red}%d%b'

# 单词中也进行补全
setopt complete_in_word

# 基于 Valodim/zsh-capture-completion
# 用 fzf 作为交互菜单
function compadd-wrapper () {
    # 解析所有参数, 避免无法识别组合参数的情况
    typeset -A apre hpre ipre hsuf asuf isuf arg_d arg_J arg_V \
         arg_X arg_x arg_r arg_R arg_W arg_F arg_M arg_O arg_A arg_D arg_E
    local flag_a flag_k flag_l flag_o flag_1 flag_2 flag_q isfile \
         flag_e flag_Q flag_n flag_U flag_C
    zparseopts -E P:=apre p:=hpre i:=ipre S:=asuf s:=hsuf I:=isuf d:=arg_d \
        J:=arg_J V:=arg_V X:=arg_X x:=arg_x r:=arg_r R:=arg_R W:=arg_W F:=arg_F \
        M:=arg_M O:=arg_O A:=arg_A D:=arg_D E:=arg_E \
        a=flag_a k=flag_k l=flag_l o=flag_o 1=flag_1 2=flag_2 q=flag_q \
        f=isfile e=flag_e Q=flag_Q n=flag_n U=flag_U C=flag_C

    # -O, -A or -D 原样传递
    if (( $#arg_O || $#arg_A || $#arg_D )) {
        builtin compadd "$@"
        return $?
    }

    # 获取所有补全和描述到 $__hits 和 $__dscr 中
    typeset -a __hits __dscr
    if (( $#arg_d == 1 )) {
        __dscr=( "${(@P)${(v)arg_d}}" )
    }
    builtin compadd -A __hits -D __dscr "$@"
    if (( $#__hits == 0 )) {
        return
    }

    # 需要记录的参数
    local -a keys=(ipre apre hpre hsuf asuf isuf IPREFIX ISUFFIX QIPREFIX QISUFFIX PREFIX SUFFIX)
    local __tmp_value=">_<"$'\0'">_<" expanded  # 随便加个值, 防止值为空导致解析出错
    for i ($keys) {
        expanded=${(P)i}
        if [[ -n $expanded ]] {
            __tmp_value+=$'\0'$i$'\0'$expanded
        }
    }

    setopt localoptions extendedglob
    local dscr
    for i ({1..$#__hits}) {
        # 参数描述
        dscr=
        if (( $#__dscr >= $i )) {
            dscr="${${${__dscr[$i]}##$__hits[$i] #}//$'\n'}"
        }
        # 是目录的话添加 '/'
        # FIXME: 含有特殊符号如 '*' 的目录无法判断 (因为包含了转义字符)
        if [[ -n isfile && -d $(echo ${~hpre}$__hits[$i]) ]] {
            __hits[$i]+=/
        }
        compcap_list[$__hits[$i]]=$__tmp_value${dscr:+$'\0'"dscr"$'\0'$dscr}
    }
}

FUZZY_COMPLETE_COMMAND='fzf'
FUZZY_COMPLETE_OPTIONS='-1 --ansi --cycle --layout=reverse --tiebreak=begin --bind tab:down,ctrl-j:accept --height=50%'

function fuzzy-select() {
    local ret
    if [[ -z $1 ]] {
        ret=$($FUZZY_COMPLETE_COMMAND ${(z)FUZZY_COMPLETE_OPTIONS})
    } else {
        ret=$($FUZZY_COMPLETE_COMMAND ${(z)FUZZY_COMPLETE_OPTIONS} -q $1)
    }
    echo ${ret%% $'\0' *}
}

function compcap-pretty-print() {
    local -i command_length=0
    for i (${(k)compcap_list}) {
        (( $#i > command_length )) && command_length=$#i
    }
    command_length+=3
    for k v (${(kv)compcap_list}) {
        local -A v=("${(@0)v}")
        if [[ -z $v[dscr] ]] {
            echo -E $k
        } else {
            printf "%-${command_length}s${v[dscr]}\n" $k$' \0 '
        }
    }
}

# TODO: 获取到结果后能否使用 compadd 来传递结果
function fuzzy-complete() {
    typeset -g -A compcap_list=()
    local selected

    zle expand-or-complete

    if (( $#compcap_list == 0 )) {
        return
    } else {
        selected=$(compcap-pretty-print | sort | fuzzy-select)
    }

    if [[ $selected != "" ]] {
        local -A v=("${(@0)${compcap_list[$selected]}}")
        # echo "\n"
        # echo -n ${compcap_list[$selected]} | hexyl
        LBUFFER=${LBUFFER/%$v[PREFIX]}$v[ipre]$v[apre]$v[hpre]$selected$v[hsuf]$v[asuf]$v[isuf]
        RBUFFER=${RBUFFER/#$v[SUFFIX]}
    }
    zle reset-prompt
}

zle -N fuzzy-complete

function disable-fuzzy-complete() {
    bindkey '^I' expand-or-complete
    unfunction compadd
}

function enable-fuzzy-complete() {
    bindkey '^I' fuzzy-complete
    function compadd() {
        compadd-wrapper "$@"
    }
}

enable-fuzzy-complete

# TODO: https://github.com/wfxr/forgit 样式的 git 命令补全

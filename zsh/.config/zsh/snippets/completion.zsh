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
    # 如果参数包含 -O, -A 或 -D 则不作处理
    if [[ ${@[1,(i)(-|--)]} == *-(O|A|D)\ * ]] {
        builtin compadd "$@"
        return $?
    }

    typeset -a __hits __dscr __tmp

    # 是否提供了 -d 开关 (后接包含参数描述的变量名)
    # 由于 -default- 这种玩意儿的存在, zparseopts 无法使用, 会被误认为组合参数
    if (( $@[(I)-d] )) { # kind of a hack, $+@[(r)-d] doesn't work because of line noise overload
        # 获取 -d 的后一个参数
        __tmp=${@[$[${@[(i)-d]}+1]]}
        # 参数描述可能是一个数组变量名称, 也可能是 inline 数组
        if [[ $__tmp == \(* ]] {
            echo "是 inline 数组!" # 由于还没有遇到过 inline 数组, 做个标记
            eval "__dscr=$__tmp"
        } else {
            __dscr=( "${(@P)__tmp}" )
        }
    }
    # 参数也有可能是用 -ld 开关提供的(如 git, kill)
    # 处理逻辑感觉差不多
    if (( $@[(I)-ld] )) {
        __tmp=${@[$[${@[(i)-ld]}+1]]}
        __dscr=( "${(@P)__tmp}" )
    }

    # FIXME: zmodload 不正常
    # 捕获补全列表, 并调整补全和提示的对应关系
    builtin compadd -A __hits -D __dscr "$@"

    [[ $#__hits == 0 ]] && return

    # extendedglob 扩展通配符, localoptions 限制选项作用域
    setopt localoptions extendedglob # norcexpandparam

    # 提取前缀和后缀
    # 补全路径时 hpre 包含了前面的路径, 能否用来简化插入时的操作呢?
    typeset -A apre hpre hsuf asuf
    zparseopts -E P:=apre p:=hpre S:=asuf s:=hsuf

    # 是否需要添加目录后缀或等于号
    integer dirsuf=0 equ=0
    # 先替换掉 -default- 和后面的 words, 然后判断是否存在 -f 开关和 -= 开关
    # '#' 代表任意数量
    [[ -z $hsuf && "${${@//-default-/}% -# *}" == *-[[:alnum:]]#f* ]] && dirsuf=1
    [[ ${@% -# *} == *-[[:alnum:]]#=* ]] && equ=1

    # 此时 $__hits 包含了所有匹配项, $__dscr 包含对应的描述
    local dsuf dscr
    for i ({1..$#__hits}) {
        # 是否添加 /
        if (( dirsuf )) && [[ -d ${hpre/#"~"/$HOME}$__hits[$i] ]] {
            dsuf=/
        } else {
            # TODO: 不能准确判断什么时候该加空格, 干脆不加
            (( equ )) && dsuf='=' || dsuf=''
        }
        # 是否显示描述
        (( $#__dscr >= $i )) && dscr="${${__dscr[$i]}##$__hits[$i] #}" || dscr=

        compcap_list[$IPREFIX$apre$hpre$__hits[$i]$hsuf$asuf$dsuf]=${dscr:-$'\0'}
    }
}

FUZZY_COMPLETE_COMMAND='fzf'
FUZZY_COMPLETE_OPTIONS='--cycle --layout=reverse --tiebreak=begin --bind tab:down,ctrl-i:down,ctrl-j:accept --height=50%'
FUZZY_COMPLETE_CHAR=' ['

function -fuzzy-select() {
    setopt localoptions shwordsplit
    if [[ $LBUFFER[-1] == " " ]] {
        $FUZZY_COMPLETE_COMMAND $FUZZY_COMPLETE_OPTIONS
    } else {
        $FUZZY_COMPLETE_COMMAND $FUZZY_COMPLETE_OPTIONS -q $1
    }
}

function -compcap-pretty-print() {
    local -i command_length=0
    for i (${(k)compcap_list}) {
        (( $#i > command_length )) && command_length=$#i
    }
    command_length+=4
    for k v (${(kv)compcap_list}) {
        if [[ $v == $'\0' ]] {
            echo $k
        } else {
            printf "%-${command_length}s$v\n" $k$' \0 '
        }
    }
}

function fuzzy-complete() {
    local -A compcap_list
    local selected tokens

    zle expand-or-complete

    tokens=(${(z)LBUFFER}) # 命令行参数风格分割

    if (( $#compcap_list == 0 )) {
        return
    } elif (( $#compcap_list == 1 )) {
        selected=${(k)compcap_list}
    } else {
        selected=$(-compcap-pretty-print | sort | -fuzzy-select $tokens[-1])
    }

    if [[ $selected != "" ]] {
        # 如果末尾不是 ' [' (注意转义), 则删掉最后一个参数,
        if [[ ($LBUFFER[-1] != " " && $LBUFFER[-1] != '[') || $LBUFFER[-2] == '\' ]] {
            LBUFFER=${LBUFFER/%$tokens[-1]}
        }
        LBUFFER+="${selected%% $'\0' *}"
        # 可能是在单词中进行的补全, 此时右边第一个参数也要删掉
        if [[ $RBUFFER[1] != " " ]] {
            tokens=(${(z)RBUFFER})
            RBUFFER=${RBUFFER/#$tokens[1]}
        }
    }
    zle reset-prompt
}

zle -N fuzzy-complete

function disable-fuzzy-complete() {
    bindkey '^I' expand-or-complete
    function compadd() {
        builtin compadd "$@"
    }
}

function enable-fuzzy-complete() {
    bindkey '^I' fuzzy-complete
    function compadd() {
        compadd-wrapper "$@"
    }
}

enable-fuzzy-complete

# TODO: https://github.com/wfxr/forgit 样式的 git 命令补全

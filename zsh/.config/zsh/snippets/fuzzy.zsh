export FZF_DEFAULT_OPTS='--color=bg+:23'

# 快速目录跳转, M-c 触发
function fz-zjump-widget() {
    local selected=$(z | fzf -n "2.." --tiebreak=end,index --tac --prompt="jump> ")
    if [[ "$selected" != "" ]] {
        builtin cd "${selected[(w)2]}"
    }
    zle reset-prompt
}

zle     -N    fz-zjump-widget
bindkey '\ec' fz-zjump-widget

# 搜索历史, C-r 触发
function fz-history-widget() {
    local selected=$(fc -rl 1 | fzf -n "2.." --tiebreak=index --prompt="cmd> ")
    if [[ "$selected" != "" ]] {
        zle vi-fetch-history -n $selected
    }
}

zle     -N   fz-history-widget
bindkey '^R' fz-history-widget

# 搜索文件, M-s 触发
# 会将 * 或 ** 替换为搜索结果
# 前者表示搜索单层, 后者表示搜索子目录
function fz-find() {
    local selected dir cut
    cut=$(grep -oP '[^* ]+(?=\*{1,2}$)' <<< $BUFFER)
    eval "dir=${cut:-.}"
    if [[ $BUFFER == *"**"* ]] {
        selected=$(fd -H . $dir | fzf --tiebreak=end,length --prompt="cd> ")
    } elif [[ $BUFFER == *"*"* ]] {
        selected=$(fd -d 1 . $dir | fzf --tiebreak=end --prompt="cd> ")
    }
    BUFFER=${BUFFER/%'*'*/}
    BUFFER=${BUFFER/%$cut/$selected}
    zle end-of-line
}

zle     -N    fz-find
bindkey '\es' fz-find

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
            echo "是行内数组!" # 由于还没有遇到过 inline 数组, 做个标记
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

    # 捕获补全列表, 并调整补全和提示的对应关系
    builtin compadd -A __hits -D __dscr "$@"

    [[ $#__hits == 0 ]] && return

    # extendedglob 扩展通配符, localoptions 限制选项作用域
    setopt localoptions extendedglob # norcexpandparam

    # 提取前缀和后缀
    # 补全路径时 hpre 包含了前面的路径, 能否用来简化插入时的操作呢?
    typeset -A apre hpre hsuf asuf
    zparseopts -E P:=apre p:=hpre S:=asuf s:=hsuf

    # 判断是否是文件, 是的话后面需要判断是否需要加上目录后缀 /
    integer dirsuf=0
    local equ
    # 先替换掉 -default- 和后面的 words, 然后判断是否存在 -f 开关
    # '#' 代表任意数量
    if [[ -z $hsuf && "${${@//-default-/}% -# *}" == *-[[:alnum:]]#f* ]] {
        dirsuf=1
    }
    # 某些参数需要接等于号
    if [[ ${@% -# *} == *-[[:alnum:]]#=* ]] {
        equ='='
    }

    # 此时 $__hits 包含了所有匹配项, $__dscr 包含对应的描述
    local dsuf dscr
    for i ({1..$#__hits}) {
        # 是否添加 /
        (( dirsuf )) && [[ -d ${hpre/#"~"/$HOME}$__hits[$i] ]] && dsuf=/ || dsuf=
        # 是否显示描述
        (( $#__dscr >= $i )) && dscr=" -- ${${__dscr[$i]}##$__hits[$i] #}" || dscr=

        # 有描述的话, 需要调整宽度
        if (( $#dscr != 0 )) {
            compcap_list[$(printf -- "$IPREFIX$apre$hpre%-32s$dsuf$hsuf$asuf$dscr\n" "$__hits[$i]$equ")]=1
        } else {
            compcap_list[$IPREFIX$apre$hpre$__hits[$i]$equ$dsuf$hsuf$asuf$dscr]=1
        }
    }
}

function fuzzy-complete() {
    typeset -A compcap_list
    local selected tokens
    local WORDCHARS=

    zle expand-or-complete
    if (( $#compcap_list == 0 )) {
        return
    } elif (( $#compcap_list == 1 )) {
        selected=${(k)compcap_list}
    } else {
        selected=$(printf -- '%s\n' "${(ok)compcap_list[@]}" | fzf --layout=reverse --tiebreak=begin --bind tab:down,ctrl-i:down,ctrl-j:accept --height=50%)
    }

    # 按命令行参数分割分割
    tokens=(${(z)LBUFFER})
    if [[ $selected != "" ]] {
        # 如果末尾是空格, 直接加参数, 需注意转义
        if [[ $LBUFFER[-1] != " " || $LBUFFER[-2] == '\' ]] {
            # 否则删掉最后一个参数, 再添加新的参数
            LBUFFER=${LBUFFER/%$tokens[-1]}
        }
        LBUFFER+="${selected%% *-- *}"
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

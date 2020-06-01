# https://superuser.com/questions/480928/is-there-any-command-like-time-but-for-memory-usage/767491
autoload -Uz colors
colors

() {
    local white_b=$fg_bold[white] blue=$fg[blue] rst=$reset_color
    TIMEFMT=("$white_b%J$rst"$'\n'
        "User: $blue%U$rst"$'\t'"System: $blue%S$rst  Total: $blue%*Es$rst"$'\n'
        "CPU:  $blue%P$rst"$'\t'"Mem:    $blue%M MB$rst")
}

SPROMPT="%B%F{yellow}zsh: correct '%R' be '%r' [nyae]?%f%b "
WORDCHARS=''
DIRSTACKSIZE=100

hash -d target=~/.cache/cargo-build
hash -d zsh=~/.config/zsh
hash -d dot=~/dotfiles
hash -d zinit=$ZDOTDIR/zinit
hash -d cache=$XDG_CACHE_HOME
hash -d share=$XDG_DATA_HOME
hash -d config=$XDG_CONFIG_HOME

export FZF_DEFAULT_OPTS='--color=bg+:23 -m --bind ctrl-space:toggle,pgup:preview-up,pgdn:preview-down'

# 直接输入路径即可跳转
setopt auto_cd
# 允许多次重定向
setopt multios
# 自动添加目录栈
setopt auto_pushd
setopt pushd_ignore_dups
# 补全列表允许不同列宽
setopt listpacked
# 交互模式下使用注释
setopt interactive_comments
# RPROMPT 执行完命令后就消除, 便于复制
setopt transient_rprompt
# setopt 输出显示开关状态
setopt ksh_option_print
# 单引号中 '' 表示一个 '
setopt rc_quotes
# 增强 glob
setopt extended_glob
# 没有匹配时原样输出 glob 而不是报错
setopt no_nomatch
# 开启拼写检查
setopt correct

export EDITOR="emacsclient -nw -c -a ''"

# rustup mirror
export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup
# export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
# export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

# speed up rustc compile
# removed because all cache has be placed in ~/.cache/cargo-build
# export RUSTC_WRAPPER=sccache

# Thanks https://blog.lilydjwg.me/2011/6/29/using-zpty-module-of-zsh.27677.html
function ptyrun() {
    zmodload zsh/zpty
    local ptyname=pty-$$ cmds
    expand_alias cmds $@
    zpty $ptyname $cmds
    if [[ ! -t 1 ]] {
        setopt local_traps
        trap '' INT
    }
    zpty -r $ptyname
    zpty -d $ptynamez
}

# https://archive.zhimingwang.org/blog/2015-09-21-zsh-51-and-bracketed-paste.html
autoload -Uz bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic

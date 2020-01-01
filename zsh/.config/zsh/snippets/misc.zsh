# https://superuser.com/questions/480928/is-there-any-command-like-time-but-for-memory-usage/767491
TIMEFMT=$'%J    user:%U system:%S cpu:%P total:%*E\nmax memory:	%M MB'
WORDCHARS=''
DIRSTACKSIZE=100

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

export EDITOR="vim"

# rustup mirror
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

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

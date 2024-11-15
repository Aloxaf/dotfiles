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
PROMPT_EOL_MARK="⏎"

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

# export EDITOR="emacsclient -nw -c -a ''"
EDITOR=vim

# rustup mirror
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

# for python-better-expections
export FORCE_COLOR=1
# 配置 GOPROXY 环境变量
export GOPROXY=https://goproxy.io,direct
# 还可以设置不走 proxy 的私有仓库或组，多个用逗号相隔（可选）
export GOPRIVATE=git.mycompany.com,github.com/my/private
# 使用 bat 作为 man 的语法高亮
#export MANPAGER="sh -c 'col -bx | bat -l man -p'"
#export MANROFFOPT='-c'

# speed up rustc compile
# removed because all cache has be placed in ~/.cache/cargo-build
# export RUSTC_WRAPPER=sccache

# https://archive.zhimingwang.org/blog/2015-09-21-zsh-51-and-bracketed-paste.html
autoload -Uz bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic

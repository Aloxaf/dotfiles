# 直接输入路径即可跳转
setopt auto_cd
# 允许多次重定向
setopt multios
# 自动添加目录栈
setopt auto_pushd
setopt pushd_ignore_dups
DIRSTACKSIZE=100
# 补全列表允许不同列宽
setopt listpacked
# 交互模式下使用注释
setopt interactive_comments
# RPROMPT 执行完命令后就消除, 便于复制
# setopt transient_rprompt
# setopt 输出显示开关状态
setopt ksh_option_print

# 缓存补全结果
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $

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
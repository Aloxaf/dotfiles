# 参考资料:
# http://zsh.sourceforge.net/Doc/Release/Completion-Widgets.html#Completion-Matching-Control
# http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Completion-System
# 可以 hook zstyle 来查看究竟请求了哪些玩意儿
# 禁用旧补全系统
zstyle ':completion:*' use-compctl false
# 缓存补全结果
zstyle ':completion:*:complete:*' use-cache 1
zstyle ':completion:*:complete:*' cache-path $ZSH_CACHE_DIR
# 方便选择
zstyle ':completion:*:*:*:*:*' menu true select search interactive
# 补全 global alias, 是否 idiomatic 呢 ?
_complete_alias() { compadd -- ${(k)galiases}; return 1 }
# 补全顺序:
# complete - 普通补全函数  _extensions - 通过 *.\t 选择扩展名
# _match - 和 _complete 类似但允许使用通配符(有了 fzf-tab 后没啥用了)
# _expand_alias - 展开别名 _ignored - 被 ignored-patterns 忽略掉的
# _files:complete_word - 补全文件
zstyle ':completion:*' completer _complete_alias _complete _extensions # _files:complete_word
# 允许小写字母匹配大写字母以及通过首字母匹配单词
# zstyle ':completion:*:complete_word:*' matcher-list '' \
zstyle ':completion:*' matcher-list '' \
    'm:{[:lower:]-}={[:upper:]_}' \
    'r:|[.,_-]=* r:|=*'
# 不分组
zstyle ':completion:*' list-grouped false
# 无列表分隔符
zstyle ':completion:*' list-separator ''
# 补全当前用户所有进程列表
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
# complete manual by their section, from grml
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
# FIXME: 有点慢
# complete user-commands for git-*
# https://pbrisbin.com/posts/deleting_git_tags_with_style/
# zstyle ':completion:*:*:git:*' user-commands ${${(M)${(k)commands}:#git-*}/git-/}
# zwc 什么的忽略掉吧
zstyle ':completion:*:*:*:*' file-patterns '^*.zwc'
zstyle ':completion:*:*:rm:*' file-patterns '*'
zstyle ':completion:*:*:gio:*' file-patterns '*'
# 好看的警告(与 fzf-tab 冲突)
zstyle ':completion:*:warnings' format '%F{red}%B-- No match for: %d --%b%f'
zstyle ':completion:*:descriptions' format '%F{yellow}-- Note: %d --%f'

# 单词中也进行补全
setopt complete_in_word

# TODO: https://github.com/wfxr/forgit 样式的 git 命令补全

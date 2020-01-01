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
# 增强版文件名补全, 貌似没办法仅仅通过 zstlye 实现仅作用于文件的效果
# 0 - 完全匹配 ( Abc -> Abc )      1 - 大写修正 ( abc -> Abc )
# 2 - 单词补全 ( f-b -> foo-bar )  3 - 后缀补全 ( .cxx -> foo.cxx )
function _files_enhance() {
    _files -M '' \
        -M 'm:{[:lower:]-}={[:upper:]_}' \
        -M 'r:|[.,_-]=* r:|=*' \
        -M 'r:|.=* r:|=*'
}
# 补全顺序:
# _complete - 普通补全函数  _extensions - 通过 *.\t 选择扩展名
# _match    - 和 _complete 类似但允许使用通配符(有了 fzf-tab 后没啥用了)
# _expand_alias - 展开别名 _ignored - 被 ignored-patterns 忽略掉的
zstyle ':completion:*' completer _expand_alias _complete _extensions _ignored _files_enhance
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
zstyle ':completion:*:*:*:*'   file-patterns '^*.(zwc|pyc):compiled-files' '*:all-files'
zstyle ':completion:*:*:rm:*'  file-patterns '*:all-files'
zstyle ':completion:*:*:gio:*' file-patterns '*:all-files'
# 好看的警告
zstyle ':completion:*:warnings' format '%F{red}%B-- No match for: %d --%b%f'
zstyle ':completion:*:descriptions' format '%F{yellow}-- Note: %d --%f'

# 单词中也进行补全
setopt complete_in_word

# TODO: https://github.com/wfxr/forgit 样式的 git 命令补全

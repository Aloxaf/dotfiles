# 限制单条历史记录长度
# return 1: will not be saved
# reutnr 2: saved on the internal history list
autoload -Uz add-zsh-hook
add-zsh-hook zshaddhistory max_history_len
function max_history_len() {
    if (($#1 > 160)) {
        return 2
    }
    return 0
}

HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=50000
SAVEHIST=100000

# 记录时间戳
setopt extended_history
# 首先移除重复历史
setopt hist_expire_dups_first
# 忽略重复
setopt hist_ignore_dups
# 忽略空格开头的命令
setopt hist_ignore_space
# 展开历史时不执行
setopt hist_verify
# 按执行顺序添加历史
setopt inc_append_history
# 更佳性能
setopt hist_fcntl_lock
# 实例之间即时共享历史
# setopt share_history
# 使用 fc -IR 读取历史  fc -IA 保存历史

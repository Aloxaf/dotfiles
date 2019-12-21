# 基于 https://github.com/Valodim/zsh-capture-completion
# 参照 https://github.com/zsh-users/zsh-autosuggestions/pull/330 应该还有优化空间

zmodload zsh/zpty || { echo 'error: missing module zsh/zpty' >&2; exit 1 }

# spawn shell
zpty z zsh -i

# line buffer for pty output
local line

setopt rcquotes
() {
    # Initialize the pty env, blocking until null byte is seen
    zpty -w z "source $1"
    zpty -r z line '*'$'\0'
} =( <<< '
# no prompt!
PROMPT=

# FIXME: "fd -" 似乎补全有 error
# Silence any error messages
exec 2>/dev/null

# load completion system
autoload compinit
compinit -d ~/.zcompdump_capture

# never run a command except cd
fake-run() {
    # 只起效一次, 因此每次补全后都要重新插入
    compprefuncs=( null-line )
    comppostfuncs=( null-line )
    if [[ $BUFFER[1,3] != "cd " ]] {
        zle kill-whole-line
    }
    zle accept-line
}
zle -N fake-run
bindkey ''^M'' fake-run
bindkey ''^J'' fake-run
bindkey ''^I'' complete-word

# send a line with null-byte at the end before and after completions are output
null-line () {
    echo -E - $''\0''
}

# never group stuff!
zstyle '':completion:*'' list-grouped false
# don''t insert tab when attempting completion on empty line
zstyle '':completion:*'' insert-tab false
# no list separator, this saves some stripping later on
zstyle '':completion:*'' list-separator ''''

# we use zparseopts
zmodload zsh/zutil

# override compadd (this our hook)
compadd () {

    # check if any of -O, -A or -D are given
    if [[ ${@[1,(i)(-|--)]} == *-(O|A|D)\ * ]]; then
        # if that is the case, just delegate and leave
        builtin compadd "$@"
        return $?
    fi

    # ok, this concerns us!
    # echo -E - got this: "$@"

    # be careful with namespacing here, we don''t want to mess with stuff that
    # should be passed to compadd!
    typeset -a __hits __dscr __tmp

    # do we have a description parameter?
    # note we don''t use zparseopts here because of combined option parameters
    # with arguments like -default- confuse it.
    if (( $@[(I)-d] )); then # kind of a hack, $+@[(r)-d] doesn''t work because of line noise overload
        # next param after -d
        __tmp=${@[$[${@[(i)-d]}+1]]}
        # description can be given as an array parameter name, or inline () array
        if [[ $__tmp == \(* ]]; then
            eval "__dscr=$__tmp"
        else
            __dscr=( "${(@P)__tmp}" )
        fi
    fi

    # capture completions by injecting -A parameter into the compadd call.
    # this takes care of matching for us.
    builtin compadd -A __hits -D __dscr "$@"

    # JESUS CHRIST IT TOOK ME FOREVER TO FIGURE OUT THIS OPTION WAS SET AND WAS MESSING WITH MY SHIT HERE
    setopt localoptions norcexpandparam extendedglob

    # extract prefixes and suffixes from compadd call. we can''t do zsh''s cool
    # -r remove-func magic, but it''s better than nothing.
    typeset -A apre hpre hsuf asuf
    zparseopts -E P:=apre p:=hpre S:=asuf s:=hsuf

    # append / to directories? we are only emulating -f in a half-assed way
    # here, but it''s better than nothing.
    integer dirsuf=0
    # don''t be fooled by -default- >.>
    if [[ -z $hsuf && "${${@//-default-/}% -# *}" == *-[[:alnum:]]#f* ]]; then
        dirsuf=1
    fi

    # just drop
    [[ -n $__hits ]] || return

    # this is the point where we have all matches in $__hits and all
    # descriptions in $__dscr!

    # display all matches
    local dsuf dscr
    for i in {1..$#__hits}; do

        # add a dir suffix?
        (( dirsuf )) && [[ -d $__hits[$i] ]] && dsuf=/ || dsuf=
        # description to be displayed afterwards
        (( $#__dscr >= $i )) && dscr=" -- ${${__dscr[$i]}##$__hits[$i] #}" || dscr=

        if (( $#__dscr >= $i )) {
            printf -- "$IPREFIX$apre$hpre%-32s$dsuf$hsuf$asuf$dscr\n" $__hits[$i]
        } else {
            echo -E - $IPREFIX$apre$hpre$__hits[$i]$dsuf$hsuf$asuf$dscr
        }

    done

}

# Signal setup completion by sending null byte
echo $''\0''
')

function zcapture() {
    zpty -w z "cd $(pwd)"
    zpty -w z "$*"$'\t'

    integer tog=0
    # read from the pty, and parse linewise
    while zpty -r z line; do
        if [[ $line == *$'\0'* ]]; then
            (( tog++ )) && return 0 || continue
        fi
        # display between toggles
        (( tog )) && echo -En - $line
    done

    return 2
}

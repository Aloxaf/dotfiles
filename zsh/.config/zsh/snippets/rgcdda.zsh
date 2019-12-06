function rgzh() {
    str=$1
    shift
    rg "$str" ~/Coding/C++/Cataclysm-DDA/lang/po/zh_CN.po "$@"
}

function rgsrc() {
    str=$1
    shift
    rg "$str" ~/Coding/C++/Cataclysm-DDA/src -I -N "$@" | bat --language=C++
}

function rgdata() {
    str=$1
    shift
    rg "$str" ~/Coding/C++/Cataclysm-DDA/data -I -N "$@" | bat --language=json
}




cite about-plugin
about-plugin 'allow on the fly theme changing for this session'

function theme
{
    if [ -z "$1" ] || [ "$1" = "random" ]; then
    themes=(`find $BASH_IT/themes -type f -name '*.theme.bash' | grep -vE 'themes/[^/]+$'`)
    N=${#themes[@]}
    ((N=(RANDOM%N)+1))
    RANDOM_THEME=${themes[$N]}
    source "$RANDOM_THEME"
    echo "[bash-it] Random theme '$RANDOM_THEME' loaded..."
    else
        source "$BASH_IT/themes/$1/$1.theme.bash"
    fi
}

function lstheme
{
    ls $BASH_IT/themes/*/*theme.bash | xargs -i% basename % .theme.bash
}

_theme() {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=($(compgen -W "$(lstheme)" -- $cur))
}
complete -F _theme theme

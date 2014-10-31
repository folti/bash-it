# scm theming
SCM_THEME_PROMPT_PREFIX="|"
SCM_THEME_PROMPT_SUFFIX=""

SCM_THEME_PROMPT_DIRTY=" ${bold_red}✗${normal}"
SCM_THEME_PROMPT_CLEAN=" ${green}✓${normal}"
SCM_GIT_CHAR="${green}±${normal}"
SCM_SVN_CHAR="${cyan}⑆${normal}"
SCM_HG_CHAR="${bold_red}☿${normal}"

### TODO: openSUSE has already colors enabled, check if those differs from stock
# LS colors, made with http://geoff.greer.fm/lscolors/
# export LSCOLORS="Gxfxcxdxbxegedabagacad"
# export LS_COLORS='no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:'

scm_prompt() {
    scm
    if [ "${SCM}" = "${SCM_NONE}" ]; then
            return
    else
        scm_prompt_vars
        if [[ $SCM_IS_TAG -eq "1" ]]; then
            tag=" $SCM_TAG_PREFIX "
        fi
        ret="[$SCM_CHAR$SCM_PREFIX$SCM_BRANCH#$SCM_CHANGE$SCM_STATE$SCM_SUFFIX$tag]"
        if [[ $SCM == $SCM_GIT ]]; then
            ret="[$SCM_CHAR$SCM_PREFIX${green}$SCM_BRANCH${yellow}#${SCM_CHANGE:0:6}${normal}$SCM_STATE$SCM_SUFFIX$tag"
            ret="$ret $SCM_GIT_BEHIND:$SCM_GIT_AHEAD:$SCM_GIT_STASH]"
        fi
        echo $ret
    fi
}

function last_status_prompt {
    if [[ "$1" -eq 0 ]]; then
        LAST_STATUS_PROMPT="${green}$1${normal}"
    else
        LAST_STATUS_PROMPT="${red}$1${normal}"
    fi
}

# stolen from powerline theme
function _folti_set_rgb_color {
    if [[ "${1}" != "-" ]]; then
        fg="38;5;${1}"
    fi
    if [[ "${2}" != "-" ]] && [[ -n "${2}" ]]; then
        bg="48;5;${2}"
        [[ -n "${fg}" ]] && bg=";${bg}"
    fi
    if [[ -n "${3}" ]]; then
        other="${3}"
        if [[ -n "${fg}" ]] || [[ -n "${bg}" ]]; then
            other=";${other}"
        fi
    fi
    echo  "\[\033[${fg}${bg}${other}m\]"
}

pure_prompt() {
    local retcode="$?"
    last_status_prompt $retcode
    case "$TERM" in
        *256color) ps_host="$(_folti_set_rgb_color 33 - 1)\h${normal}";;
        *) ps_host="$(color blue bold)\h${normal}";;
    esac
    ps_user="${green}\u${normal}";
    ps_user_mark="${green}\n$LAST_STATUS_PROMPT $ ${normal}";
    ps_root="${red}\u${red}";
    ps_root="${red} # ${normal}"
    ps_path="${yellow}\w${normal}";

    # make it work
    case $(id -u) in
        0) PS1="$ps_root@$ps_host$(scm_prompt):$ps_path$ps_root_mark"
            ;;
        *) PS1="$ps_user@$ps_host$(scm_prompt):$ps_path$ps_user_mark"
            ;;
    esac
}

PROMPT_COMMAND=pure_prompt;

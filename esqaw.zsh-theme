local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"


PROMPT_SUCCESS_COLOR=$FG[117]
PROMPT_FAILURE_COLOR=$FG[124]
PROMPT_VCS_INFO_COLOR=$FG[242]
PROMPT_PROMPT=$FG[077]
GIT_DIRTY_COLOR=$FG[133]
GIT_CLEAN_COLOR=$FG[118]
GIT_PROMPT_INFO=$FG[012]


ZSH_THEME_GIT_PROMPT_PREFIX=" ⭠ %{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$GIT_PROMPT_INFO%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$GIT_DIRTY_COLOR%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$GIT_CLEAN_COLOR%}✔"

ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[082]%}✚%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[166]%}✹%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[160]%}✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[220]%}➜%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[082]%}═%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[190]%}✭%{$reset_color%}"


function get_random_color {
  python -c "
import random
import socket

random.seed(socket.gethostname())
for _ in range($1):
  random.randint(0, 255)
print '{:3d}'.format(random.randint(0, 255))
"
}

function enabled_git_info {
  if ( ! $ZSH_THEME_DISABLE_GIT_STATUS ) ; then
    echo "$(git_prompt_info)%{$reset_color%}"
  fi
}

local host_status="%{$FG[$(get_random_color 1)]%}%n@%m%{$reset_color%}"
local directory="%{$FG[$(get_random_color 3)]%}%d%{$reset_color%}"

PROMPT='${ret_status} ${host_status} ${directory}  $(enabled_git_info) ⌚ %D{%H:%M}%{$reset_color%}
%% '


LASTCMD_START=0
function microtime()
{
  if [[ "$OSTYPE" == "darwin"* ]]; then
    date +'%s' 
  else
    date +'%s.%N' 
  fi 
}


#called before user command
function preexec(){
  #set_titlebar $TITLEHOST\$ "$1"
  LASTCMD_START=`microtime` 
  LASTCMD="$1"
}

#called after user cmd
function precmd(){ 
  if [[ "$LEGACY_ZSH" != "1" ]]
  then
    #set_titlebar "$TITLEHOST:`echo "$PWD" | sed "s@^$HOME@~@"`"
    local T=0 ; (( T = `microtime` - $LASTCMD_START ))
    if (( $LASTCMD_START > 0 )) && (( T>1 ))
    then
      T=`echo $T | head -c 10` 
      LASTCMD=`echo "$LASTCMD" | grep -ioG '^[a-z0-9./_-]*'`
      echo "$LASTCMD took $T seconds"
    fi
    LASTCMD_START=0
  fi
}


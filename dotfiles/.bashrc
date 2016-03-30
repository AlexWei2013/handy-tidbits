# To the extent possible under law, the author(s) have dedicated all 
# copyright and related and neighboring rights to this software to the 
# public domain worldwide. This software is distributed without any warranty. 
# You should have received a copy of the CC0 Public Domain Dedication along 
# with this software. 
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>. 

# base-files version 4.2-3

# ~/.bashrc: executed by bash(1) for interactive shells.

[[ "$-" != *i* ]] && return

set -o vi
alias ls='ls -hF --color=tty'
alias ll='ls -last --color=tty'                 # classify files in colour
alias clear='printf "\033c"'
alias vi=vim

# ssh-pageant
eval $(/usr/bin/ssh-pageant -r -a "/tmp/.ssh-pageant-$USERNAME")
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

## see http://randomartifacts.blogspot.com/2012/10/a-proper-cygwin-environment.html

# get ze colors
eval `dircolors ~/profile/colors/dircolors.ansi-light`

# get current git branch name
function git_branch {
    export gitbranch=[$(git rev-parse --abbrev-ref HEAD 2>/dev/null)] 
    gitbranch="$gitbranch "
    if [ "$?" -ne 0 ]
      then gitbranch=
    fi
    if [[ "${gitbranch}" == "[] " ]]
      then gitbranch=
    fi
}

# Set prompt and window title
inputcolor='[0;37m'
cwdcolor='[0;34m'
gitcolor='[1;31m'

 
# Setup for window title
export TTYNAME=$$
function settitle() {
  p=$(pwd);
  let l=${#p}-25
  if [ "$l" -gt "0" ]; then
    p=..${p:${l}}
  fi
  t="$TTYNAME $p"
  echo -ne "\e]2;$t\a\e]1;$t\a";
}
 
PROMPT_COMMAND='git_branch; settitle; history -a;'
export PS1='\u@\H \[\e${gitcolor}\]${gitbranch}\[\e[32;1m\]\w\[\e[0m\]\n\t \$ ' 
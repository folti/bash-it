#!/usr/bin/env bash

# Bash History Handling

shopt -s histappend                                      # append to bash_history if Terminal.app quits
export HISTCONTROL=${HISTCONTROL:-ignorespace:erasedups} # erase duplicates; alternative option: export HISTCONTROL=ignoredups
export HISTSIZE=${HISTSIZE:-5000}                        # resize history size
export AUTOFEATURE=${AUTOFEATURE:-true autotest}         # Cucumber / Autotest integration

# ugly hack for Midnight Commander. It's needed to prevent MC to pollute the
# history with 'cd "printf ...' lines for every directory change ..
# See: http://www.midnight-commander.org/wiki/doc/faq#a6.8Iseelotofstrangecdprintflinesintomy.historyfile
if [ -n "$MC_SID" ]; then
  export HISTCONTROL=ignoreboth
fi

function rh {
  history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}

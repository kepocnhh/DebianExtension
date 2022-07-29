#!/bin/bash

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

$DEBIAN_EXTENSION_HOME/common/install_package.sh git || exit 21

touch $HOME/.bash_aliases
echo "
alias gits=\"git status -s -b\"
alias gitlog=\"git log --graph --oneline --all -16\"
alias gitpull=\"git pull --ff-only\"
alias gitmerge=\"git merge --ff-only\"
" >> $HOME/.bash_aliases

git --version

exit 0

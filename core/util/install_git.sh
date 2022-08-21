#!/bin/bash

for it in HOME DEBIAN_EXTENSION_HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 11; fi; done

$DEBIAN_EXTENSION_HOME/common/install_package.sh git || exit 21

mkdir $HOME/.local
echo "
alias gits=\"git status -s -b\"
alias gitlog=\"git log --graph --oneline --all -16\"
alias gitpull=\"git pull --ff-only\"
alias gitmerge=\"git merge --ff-only\"
" >> $HOME/.local/aliases

git --version

exit 0

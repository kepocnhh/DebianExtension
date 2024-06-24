#!/bin/bash

echo "Install xresources..."

for it in HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 11; fi; done

RESULT_PATH="$HOME/.Xresources"

rm "$RESULT_PATH"

cp './xserver/wm/res/.Xresources' "$RESULT_PATH"
if test $? -ne 0; then
 echo 'Copy xresources file error!'; exit 21; fi

exit 0

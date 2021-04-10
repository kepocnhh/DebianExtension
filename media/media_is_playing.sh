#!/bin/bash

ERROR_CODE_PLAYERS=10
ERROR_CODE_PLAYERS=11

CODE=0

PLAYERS=$(/usr/bin/playerctl -l); CODE=$?
if test $CODE -ne 0; then
 echo "Screensaver state error $CODE!"
 exit $ERROR_CODE_PLAYERS
fi
[[ -z "$PLAYERS" ]] && exit 0

while read -r PLAYER; do
 [[ -z "$PLAYER" ]] && continue
 STATUS=$(/usr/bin/playerctl --player="$PLAYER" status)
 [[ $? -ne 0 ]] && continue # todo
 case "$STATUS" in
  "Playing")
   echo "true"
   exit 0
  ;;
 esac
done <<< "$PLAYERS"

exit 0

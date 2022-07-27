#!/bin/bash

ERROR_CODE_PLAYERS=10

CODE=0

PLAYERS=$(/usr/bin/playerctl -l); CODE=$?
[[ $CODE -ne 0 ]] && exit $ERROR_CODE_PLAYERS
[[ -z "$PLAYERS" ]] && exit 0

while read -r PLAYER; do
 [[ -z "$PLAYER" ]] && continue
 STATUS=$(/usr/bin/playerctl --player="$PLAYER" status); CODE=$?
 [[ $CODE -ne 0 ]] && continue # todo
 case "$STATUS" in
  "Playing")
   echo "true"
   exit 0
  ;;
 esac
done <<< "$PLAYERS"

echo "false"

exit 0

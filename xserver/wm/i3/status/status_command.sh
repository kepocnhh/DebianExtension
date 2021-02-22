echo '{"version":1}'
echo '['
echo '[]'

while :; do
 TIME=$(date +"%Y/%m/%d %H:%M:%S")
 RESULT="{\"full_text\":\"$TIME\"}"

echo ",[$RESULT]"
done

exit 0

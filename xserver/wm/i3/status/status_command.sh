echo '{"version":1}'
echo '['
echo '[]'

while :; do
 TIME=$(date +"%Y/%m/%d %H:%M:%S")
 RESULT="{\"full_text\":\"$TIME\"}"
done

exit 0

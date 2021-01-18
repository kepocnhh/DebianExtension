NAME_FONT=JetBrainsMono
echo "download font $NAME_FONT..."

ERROR_CODE_DOWNLOAD=1
ERROR_CODE_UNZIP=2
ERROR_CODE_MOVE=3

VERSION_FONT="2.221"
DOWNLOAD_URL=https://github.com/JetBrains/JetBrainsMono/releases/download/v${VERSION_FONT}/JetBrainsMono-${VERSION_FONT}.zip

TMP_FILE_PATH=/tmp/font_$NAME_FONT.zip

curl -s $DOWNLOAD_URL -o $TMP_FILE_PATH || STATUS=$?
if test $STATUS -ne 0; then
	echo "download font $NAME_FONT error!"
    exit $ERROR_CODE_DOWNLOAD
fi

echo "unzip font $NAME_FONT..."

TMP_UNZIP_PATH=/tmp/font_$NAME_FONT

unzip $TMP_FILE_PATH -d $TMP_UNZIP_PATH || STATUS=$?
if test $STATUS -ne 0; then
	echo "unzip font $NAME_FONT error!"
    exit $ERROR_CODE_UNZIP
fi

rm $TMP_FILE_PATH

echo "move font $NAME_FONT..."

RESULT_PATH=/usr/share/fonts/truetype/$NAME_FONT

mv $TMP_UNZIP_PATH/ttf $RESULT_PATH || STATUS=$?
if test $STATUS -ne 0; then
	echo "move font $NAME_FONT error!"
    exit $ERROR_CODE_MOVE
fi

rm -rf $TMP_UNZIP_PATH

exit 0

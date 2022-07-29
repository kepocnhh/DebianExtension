#!/bin/bash

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

NAME_FONT=JetBrainsMono
echo "Download font ${NAME_FONT}..."

ERROR_CODE_MOVE=3

# VERSION_FONT="2.221"
VERSION_FONT="2.242"
DOWNLOAD_URL=https://github.com/JetBrains/JetBrainsMono/releases/download/v${VERSION_FONT}/JetBrainsMono-${VERSION_FONT}.zip

TMP_FILE_PATH="/tmp/font_${NAME_FONT}.zip"
rm $TMP_FILE_PATH

curl -L $DOWNLOAD_URL -o $TMP_FILE_PATH
if test $? -ne 0; then
 echo "Download font $NAME_FONT error!"; exit 21
fi

echo "Unzip font ${NAME_FONT}..."

TMP_UNZIP_PATH="/tmp/font_${NAME_FONT}"
rm -rf $TMP_UNZIP_PATH

unzip -q $TMP_FILE_PATH -d $TMP_UNZIP_PATH
if test $? -ne 0; then
 echo "Unzip font $NAME_FONT error!"; exit 22
fi

rm $TMP_FILE_PATH

echo "Move font $NAME_FONT..."

RESULT_PATH=/usr/share/fonts/truetype/$NAME_FONT
rm -rf $RESULT_PATH

mv $TMP_UNZIP_PATH/fonts/ttf $RESULT_PATH
if test $? -ne 0; then
 echo "Move font $NAME_FONT error!"; exit 23
fi

rm -rf $TMP_UNZIP_PATH

exit 0

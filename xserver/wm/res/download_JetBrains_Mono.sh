echo "download font jetbrains mono..."

ERROR_CODE_CURL=1

VERSION="2.001"

STATUS=0

curl -L https://download.jetbrains.com/fonts/JetBrainsMono-${VERSION}.zip -o JetBrainsMono.zip || STATUS=$?
if test $STATUS -ne 0; then
	echo "download font jetbrains mono error!"
    exit $ERROR_CODE_CURL
fi

echo "download font jetbrains mono success."

exit 0

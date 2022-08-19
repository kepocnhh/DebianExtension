#!/bin/bash

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

LATEST_VERSIONS="$(curl -s https://www.python.org/ftp/python/ \
 | grep -E '^<a href="[1-9].[0-9]' \
 | grep -Po '(?<=<a href=")[1-9].[0-9]+(.[0-9]+)?' \
 | sort -V | tail -n 16)"
if test $? -ne 0; then
 echo "Get latest versions python error!"; exit 12
elif test -z "$LATEST_VERSIONS"; then
 echo "Latest versions python is empty!"; exit 13
fi

PYTHON_VERSION=""
echo "
Latest 16 versions:
$LATEST_VERSIONS

Enter python version:"
while : ; do
 read -n1 char
 if test -z $char; then
  echo; break
 else
  PYTHON_VERSION+=$char
 fi
done

for it in PYTHON_VERSION; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 21; fi; done

if test -d "/opt/Python-$PYTHON_VERSION"; then
 echo "Python ${PYTHON_VERSION} exists!"; exit 22
fi

docker stop python$PYTHON_VERSION
docker rm python$PYTHON_VERSION
docker build \
 --build-arg PYTHON_VERSION=$PYTHON_VERSION \
 -f=$DEBIAN_EXTENSION_HOME/core/util/python/Dockerfile \
 -t=python:$PYTHON_VERSION . \
 && docker run --name=python$PYTHON_VERSION python:$PYTHON_VERSION \
 && docker cp python$PYTHON_VERSION:/opt/Python-${PYTHON_VERSION} /opt/ \
 && docker stop python$PYTHON_VERSION && docker rm python$PYTHON_VERSION

/opt/Python-${PYTHON_VERSION}/python --version
if test $? -ne 0; then
 echo "Running python $PYTHON_VERSION error!"; exit 31
fi

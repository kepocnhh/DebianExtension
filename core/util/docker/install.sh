#!/bin/bash

if [ ! -d "$DEBIAN_EXTENSION_HOME" ]; then
 echo "Dir $DEBIAN_EXTENSION_HOME does not exist!"; exit 11
fi

MACHINE_HARDWARE_NAME="$(/usr/bin/uname -m)"

. /etc/os-release

for it in MACHINE_HARDWARE_NAME ID VERSION_CODENAME; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 11; fi; done

case "$MACHINE_HARDWARE_NAME" in
 'x86_64') ARCHITECTURE=amd64;;
 *) echo "Architecture $MACHINE_HARDWARE_NAME is not supported!"; exit 12;;
esac

VERSIONS="$($DEBIAN_EXTENSION_HOME/core/util/docker/versions.sh)"

LEFT='(?<=docker-ce-cli_)'
RIGHT="(?=~3-0~${ID}-${VERSION_CODENAME}_${ARCHITECTURE})"
DOCKER_VERSION=""
echo "
$(echo $VERSIONS | grep -Po "${LEFT}\S+${RIGHT}" | sort -V)

Enter docker version:"
while : ; do
 read -n1 char
 if test -z $char; then
  echo; break
 else
  DOCKER_VERSION+=$char
 fi
done

LEFT='(?<=containerd.io_)'
RIGHT="(?=-1_${ARCHITECTURE})"
CONTAINERD_VERSION=""
echo "
$(echo $VERSIONS | grep -Po "${LEFT}\S+${RIGHT}" | sort -V)

Enter containerd version:"
while : ; do
 read -n1 char
 if test -z $char; then
  echo; break
 else
  CONTAINERD_VERSION+=$char
 fi
done

LEFT='(?<=docker-ce_)'
RIGHT="(?=~3-0~${ID}-${VERSION_CODENAME}_${ARCHITECTURE})"
DOCKERD_VERSION=""
echo "
$(echo $VERSIONS | grep -Po "${LEFT}\S+${RIGHT}" | sort -V)

Enter dockerd version:"
while : ; do
 read -n1 char
 if test -z $char; then
  echo; break
 else
  DOCKERD_VERSION+=$char
 fi
done

for it in DOCKER_VERSION CONTAINERD_VERSION DOCKERD_VERSION; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 11; fi; done

exit 1 # todo

echo "
$ sudo groupadd docker
$ sudo usermod -aG docker \$USER
$ exit
"

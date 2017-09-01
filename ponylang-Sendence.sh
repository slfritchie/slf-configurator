#!/bin/sh

. ./base.env

. ./setup-usr-local-src.sh

mkdir -p /usr/local/src/pony/Sendence
cd /usr/local/src/pony/Sendence

if [ ! -d ponyc ]; then
	git clone https://github.com/Sendence/ponyc
fi

cd ponyc
git checkout master

case $OS_DISTRO in
    osx)
	echo not ready ; exit 1
    ;;
    ubuntu)
	MAKE=make
    ;;
    centos)
	echo not ready ; exit 1
    ;;
    freebsd)
	MAKE=gmake
    ;;
esac

$MAKE clean && $MAKE verbose=1 -j4 && $MAKE destdir=/usr/local/pony/Sendence verbose=1 install && $MAKE clean && exit 0

exit 1

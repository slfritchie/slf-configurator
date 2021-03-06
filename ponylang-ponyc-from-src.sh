#!/bin/sh

. ./base.env

. ./setup-usr-local-src.sh

mkdir -p /usr/local/src/pony/ponylang
cd /usr/local/src/pony/ponylang

if [ ! -d ponylang/ponyc ]; then
	git clone https://github.com/ponylang/ponyc
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

$MAKE clean && $MAKE -j4 && $MAKE destdir=/usr/local/pony/ponylang install && $MAKE clean && exit 0

exit 1

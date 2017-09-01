#!/bin/sh

. ./base.env

. ./setup-usr-local-src.sh

export PATH=/usr/local/pony/ponylang/bin:$PATH

mkdir -p /usr/local/src/pony
cd /usr/local/src/pony

if [ ! -d pony-stable ]; then
	git clone https://github.com/ponylang/pony-stable.git
fi

cd pony-stable
git checkout master

case $OS_DISTRO in
    osx)
	MAKE=make
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

$MAKE clean && $MAKE && $MAKE install && $MAKE clean && exit 0

exit 1

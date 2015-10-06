#!/bin/sh

. ./base.env

case $OS_DISTRO in
    osx)
        echo "Use MacPorts?"
    ;;
    ubuntu)
        echo not ready ; exit 1
    ;;
    centos)
        echo not ready ; exit 1
    ;;
    freebsd)
        env ASSUME_ALWAYS_YES=yes pkg install -f \
		gnupg20
    ;;
    smartos)
        echo not ready ; exit 1
    ;;
esac

exit 0

#!/bin/sh

. ./base.env

case $OS_DISTRO in
    osx)
        echo No SystemTap for OS X
    ;;
    ubuntu)
        apt-get install -y \
            systemtap systemtap-sdt-dev systemtap-runtime
    ;;
    centos)
        echo TODO: Full recipe for CentOS
        exit 1
    ;;
    freebsd)
        echo No SystemTap for FreeBSD
    ;;
    smartos)
        echo No SystemTap for SmartOS
    ;;
esac

exit 0

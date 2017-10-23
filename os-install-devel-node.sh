#!/bin/sh

. ./base.env

case $OS_DISTRO in
    osx)
        echo TODO ; exit 1
    ;;
    ubuntu)
        sudo apt-get install -y npm
        sudo ln -s ./nodejs /usr/bin/node
        ## TODO move elsewhere.
        sudo npm install -g node-sass browserify
    ;;
    centos)
        echo TODO ; exit 1
    ;;
    freebsd)
        echo TODO ; exit 1
    ;;
    smartos)
        echo TODO ; exit 1
    ;;
    omnios)
        echo TODO ; exit 1
    ;;
esac

exit 0

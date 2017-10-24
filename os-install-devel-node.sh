#!/bin/sh

. ./base.env

case $OS_DISTRO in
    osx)
        echo TODO ; exit 1
    ;;
    ubuntu)
        sudo apt-get install -y npm
        sudo ln -s ./nodejs /usr/bin/node

        ## TODO move this sub-package installation elsewhere.

        # Avoid problem when installing node-sass on Ubuntu Trusty/14.04
        # 2017-10-23 work-around: request specific version.
        # /usr/local/lib/node_modules/node-sass/node_modules/request/node_modules/hawk/node_modules/boom/lib/index.js:5
        # const Hoek = require('hoek');
        # ^^^^^
        # SyntaxError: Use of const in strict mode.

        npm install node-sass request@2.81.0
        npm install browserify
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

#!/bin/sh

. ./base.env

case $OS_DISTRO in
    osx)
        echo TODO installing XCode and XCode command line utilities?
    ;;
    ubuntu)
        # See also: https://github.com/gordonguthrie/vagrant-riak.2.0.2-ubuntu-trusty-x64_86/blob/master/provision-riak-2.0.2.vagrant
        apt-get install -y \
            git libncurses5-dev xsltproc libssl-dev autoconf automake \
            libpam0g-dev
    ;;
    centos)
        yum install -y \
	    git ncurses-devel openssl-devel libtool ncompress
    ;;
    freebsd)
        ## WEIRD: 'pkg' install of gcc doesn't have 'gcc' executable anywhere?
        env ASSUME_ALWAYS_YES=yes pkg install -f \
            git ncurses openssl libtool gmake
    ;;
    smartos)
        pkgin -y install \
            git-base ncurses openssl libtool gmake
    ;;
    omnios)
        pkg install developer/gcc48 system/header developer/object-file system/library/math system/library/math/header-math developer/build/gnu-make developer/build/autoconf developer/build/libtool developer/debug/mdb developer/dtrace developer/dtrace/toolkit developer/gnu-binutils developer/versioning/git library/ncurses library/security/openssl library/zlib network/netcat network/rsync security/sudo shell/tcsh terminal/tmux text/gawk text/gnu-diffutils text/gnu-grep text/gnu-patch text/gnu-sed text/less web/curl web/wget
        PATH=${PATH}:/opt/gcc-4.8.1/bin
        export PATH
    ;;
esac

exit 0

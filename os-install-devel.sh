#!/bin/sh

. ./base.env

case $OS_DISTRO in
    osx)
        echo TODO installing XCode and XCode command line utilities?
    ;;
    ubuntu)
        grep -s llvm-toolchain-xenial-3.9 /etc/apt/sources.list
        if [ $? -ne 0 ]; then
            cat <<EOF >> /etc/apt/sources.list
deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-3.9 main
deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-3.9 main
EOF
            cd /tmp
            wget -O llvm-snapshot.gpg.key http://apt.llvm.org/llvm-snapshot.gpg.key
            sudo apt-key add llvm-snapshot.gpg.key
            apt-get update
        fi
        # See also: https://github.com/gordonguthrie/vagrant-riak.2.0.2-ubuntu-trusty-x64_86/blob/master/provision-riak-2.0.2.vagrant
        apt-get install -y \
            build-essential \
            git git-core expect \
            zlib1g-dev libncurses5-dev libssl-dev libpcre2-dev llvm-3.9
    ;;
    centos)
        yum install -y \
	    make gcc gcc-c++ kernel-devel m4 \
            git expect patch
    ;;
    freebsd)
        ## WEIRD: 'pkg' install of gcc doesn't have 'gcc' executable anywhere?
        env ASSUME_ALWAYS_YES=yes pkg install -f \
            llvm39 libunwind pcre2 \
	    m4 autoconf autotools \
            git gmake expect
    ;;
    smartos)
        pkgin -y install gcc47 m4 autoconf \
            git-base gmake expect
    ;;
esac

exit 0
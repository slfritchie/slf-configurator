#!/bin/sh

. ./base.env

case $OS_DISTRO in
    osx)
        echo TODO incomplete
        exit 1
    ;;
    ubuntu)
        # Installing git
        sudo apt-get install -y git

        # Installing make
        sudo apt-get update
        sudo apt-get install -y build-essential

        # Sendence's ponyc & Wallaroo requires gcc 5 for its atomics support
	sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
        sudo apt-get update
        sudo apt-get libssl-dev
        sudo apt-get install -y gcc-5 g++-5
        sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5

        # Installing ponyc
        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "D401AB61 DBE1D0A2"
        grep -s pony-language/ponyc-debian /etc/apt/sources.list
        if [ $? -ne 0 ]; then
            cat <<EOF >> /etc/apt/sources.list
deb https://dl.bintray.com/pony-language/ponyc-debian pony-language main
EOF
        fi
        sudo apt-get update
        sudo apt-get -V -y install ponyc

        # Installing pony-stable
        grep -s pony-language/pony-stable-debian /etc/apt/sources.list
        if [ $? -ne 0 ]; then
            echo "deb https://dl.bintray.com/pony-language/pony-stable-debian /" | sudo tee -a /etc/apt/sources.list
        fi
        sudo apt-get update
        sudo apt-get -V -y install pony-stable

        # Install compression development libraries
        case $DISTRIB_CODENAME in
            trusty)
                sudo apt-get install -y libsnappy-dev
                ( cd /tmp
                  wget -O liblz4-1.7.5.tar.gz https://github.com/lz4/lz4/archive/v1.7.5.tar.gz
                  tar zxvf liblz4-1.7.5.tar.gz
                  cd lz4-1.7.5
                  make
                  sudo make install
                )
                ;;
            *)
		# Assume that we're on a version later than trusty
                sudo apt-get install -y libsnappy-dev liblz4-dev
                ;;
        esac

        ## Install Python Development Libraries
        sudo apt-get install -y python-dev
    ;;
    centos)
        echo "TODO, aborting!"
        exit 1
        yum install -y \
	    make gcc gcc-c++ kernel-devel m4 \
            git expect patch
    ;;
    freebsd)
        echo "TODO, aborting!"
        exit 1
        ## WEIRD: 'pkg' install of gcc doesn't have 'gcc' executable anywhere?
        env ASSUME_ALWAYS_YES=yes pkg install -f \
            llvm39 libunwind pcre2 \
	    m4 autoconf autotools \
            git gmake expect
    ;;
    smartos)
        echo "TODO, aborting!"
        exit 1
        pkgin -y install gcc47 m4 autoconf \
            git-base gmake expect
    ;;
esac

exit 0

#!/bin/sh

. ./base.env

case $OS_DISTRO in
    osx)
        echo TODO ; exit 1
    ;;
    ubuntu)
        ## http://elixir-lang.org/install.html
        cat<<EOF > /dev/null
        (cd /tmp ; rm -f erlang-solutions_1.0_all.deb;
         wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
        )
        sudo apt-get update
        ## Hmmmm, 2017-10-23 installs Erlang/OTP 20.x
        sudo apt-get install -y esl-erlang
        ## ... and there's a warning about:
        ## ** (CompileError) lib/market_spread_reports_ui/endpoint.ex:1: inlined function current_time/0 undefined
        sudo apt-get install -y elixir
EOF
        ## Compile & install Erlang/OTP 19.3.
        (
            cd /tmp
            rm -rf otp_src_19.3*
            wget http://erlang.org/download/otp_src_19.3.tar.gz
            tar xf otp_src_19.3.tar.gz
            cd otp_src_19.3
            ./configure --prefix=/usr/local/erlang/19.3
            make install
        )
        ## Compile & install Elixir
        (
            ELIXIR_VERSION=v1.2.6
            cd /tmp
            rm -rf elixir
            git clone https://github.com/elixir-lang/elixir.git
            cd elixir
            git checkout $ELIXIR_VERSION
            make clean
            make
            env PREFIX=/usr/local/elixir/$ELIXIR_VERSION make install
        )
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

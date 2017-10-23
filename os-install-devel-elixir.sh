#!/bin/sh

. ./base.env

case $OS_DISTRO in
    osx)
        echo TODO ; exit 1
    ;;
    ubuntu)
        ## http://elixir-lang.org/install.html
        (cd /tmp ; rm -f erlang-solutions_1.0_all.deb;
         wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
        )
        sudo apt-get update
        sudo apt-get install -y esl-erlang
        sudo apt-get install -y elixir
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

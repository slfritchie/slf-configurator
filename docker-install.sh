#!/bin/sh

. ./base.env

case $OS_DISTRO in
    osx)
        echo TODO unfinished ; exit 1
    ;;
    ubuntu)
        # Instructions at https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository
        sudo apt-get update
        sudo apt-get -y install apt-transport-https ca-certificates \
             curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
            sudo apt-key add -

        grep -s docker /etc/apt/sources.list
        if [ $? -ne 0 ]; then
            sudo add-apt-repository \
                "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
                $(lsb_release -cs) stable"
            apt-get update
        fi

        sudo apt-get -y install docker-ce docker-compose
        /etc/init.d/docker start
    ;;
    centos)
        echo TODO unfinished ; exit 1
    ;;
    freebsd)
        echo TODO unfinished ; exit 1
    ;;
    smartos)
        echo TODO unfinished ; exit 1
    ;;
esac

exit 0

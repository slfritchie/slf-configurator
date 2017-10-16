#!/bin/sh

. ./base.env

case $OS_DISTRO in
    osx)
        echo TODO, exiting
        exit 1
    ;;
    ubuntu)
        ## Install Docker
        ## We will use the CE (Community Edition)
        ## https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#recommended-extra-packages-for-trusty-1404
        ## https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository
        case $DISTRIB_CODENAME in
            trusty)
                sudo apt-get install -y \
                     linux-image-extra-$(uname -r) \
                     linux-image-extra-virtual
                ;;
        esac
        sudo apt-get install -y \
             apt-transport-https \
             ca-certificates \
             curl \
             software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository \
             "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
                $(lsb_release -cs) \
                   stable"
        sudo apt-get install -y docker-ce
    ;;
    centos)
        echo TODO, exiting
        exit 1
    ;;
    freebsd)
        echo TODO, exiting
        exit 1
    ;;
    smartos)
        echo TODO, exiting
        exit 1
    ;;
esac

exit 0

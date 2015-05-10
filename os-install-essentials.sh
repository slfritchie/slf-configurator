#!/bin/sh

. ./base.env

case $OS_DISTRO in
    osx)
        echo Done, easy, mostly, except for TODO installing MacPorts?
    ;;
    ubuntu)
        sed -i 's/#deb/deb/g' /etc/apt/sources.list 
        sed -i 's/deb cdrom/# deb cdrom/g' /etc/apt/sources.list
        apt-get update
        apt-get install -y \
	    man sudo curl less tmux wget \
            htop iftop dstat lsof rsync s3cmd
    ;;
    centos)
        sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/CentOS-Base.repo
        yum install -y \
            man sudo curl less tmux wget \
            htop iftop dstat lsof rsync s3cmd
        # NOTE: centos6: not found: htop tmux iftop
    ;;
    freebsd)
        env ASSUME_ALWAYS_YES=yes pkg install -f \
                sudo curl less tmux wget \
            htop iftop       lsof rsync py27-s3cmd

        # Post-install goop for htop
        if [ ! -d /usr/compat/linux/proc ]; then
            mkdir -p /usr/compat/linux/proc
            ln -s /usr/compat /compat
            egrep -s "^linproc" /etc/fstab
            if [ $? -ne 0 ]; then
                echo "linproc /compat/linux/proc linprocfs rw,late 0 0" >> /etc/fstab
            fi
            mount linproc
        fi
    ;;
    smartos)
        pkgin update
        pkgin -y install curl less tmux wget htop iftop rsync s3cmd
    ;;
esac

exit 0

#!/bin/sh

. ./base.env

case $OS_DISTRO in
    osx)
        echo TODO unfinished ; exit 1
    ;;
    ubuntu)
        # Based on https://gist.github.com/monkut/07cd1618102cbae8d587811654c92902
	# Add kafka user
        sudo useradd kafka -m

	# Install Java
	sudo apt-get update
	sudo apt-get install -y default-jre wget

	# Install Zookeeper
	sudo apt-get install -y zookeeperd

	# Download & install Kafka
        # https://kafka.apache.org/downloads
	KVERSION=0.11.0.1
	KBASE=kafka_2.12-$KVERSION
	KFILE=${KBASE}.tgz
	(
	  wget http://apache.cs.utah.edu/kafka/$KVERSION/$KFILE
	  tar xvf $KFILE
	  mkdir -p /usr/local/kafka
	  sudo mv $KBASE /usr/local/kafka
	  rm $KFILE
	)
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

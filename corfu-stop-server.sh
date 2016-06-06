#!/bin/sh

env="$1"
type="$2"
num="$3"

source $env
source ./corfu-cluster.sh

pid_path=`corfu_fmt_pid_path $type $num`
pid=`cat $pid_path`
if [ -z "$pid" ]; then
    echo "ERROR: pid for type $type number $num does not exist"
    exit 1
fi

# NOTE: $pid is the parent bash/shell wrapper process.
#       We want to kill it and also its child Java VM process
pgrep -P $pid > /dev/null 2>&1
if [ $? -eq 0 ]; then
    pkill -P $pid
    if [ $? -eq 0 ]; then
	rm $pid_path
    fi
else
    echo "ERROR: pid $pid for type $type number $num is invalid"
    exit 1
fi

exit 0

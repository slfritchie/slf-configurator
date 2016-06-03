#!/bin/sh

env="$1"
type="$2"
num="$3"

source $env
source ./corfu-cluster.sh

pid_dir=$CORFU_LOG_DIR/pid
case $type in
    seq*)
	type=seq
	;;
    lay*)
	type=layout
	;;
    log*)
	type=log
	;;
    *)
	echo "Usage: $0 seq|layout|log instance-number"
	exit 1
esac

pid_file=$pid_dir/$type.$num
pid=`cat $pid_file`

# NOTE: $pid is the parent bash/shell wrapper process.
#       We want to kill it and also its child Java VM process
pgrep -P $pid > /dev/null 2>&1
if [ $? -eq 0 ]; then
    pkill -P $pid
else
    echo "ERROR: pid for type $type number $num does not exist"
fi

exit 0

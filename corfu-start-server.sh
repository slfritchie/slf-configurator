#!/bin/sh

env="$1"
type="$2"
num="$3"

source $env
source ./corfu-cluster.sh

console_file=`corfu_fmt_console_path $type $num`
mkdir -p `dirname $console_file`
pid_path=`corfu_fmt_pid_path $type $num`
mkdir -p `dirname $pid_path`
case $type in
    seq*)
	type=seq
	exec `corfu_fmt_sequencer_cmd $num` >> $console_file 2>&1 &
	;;
    lay*)
	type=layout
	exec `corfu_fmt_layout_cmd $num` >> $console_file 2>&1 &
	;;
    log*)
	type=log
	exec `corfu_fmt_log_cmd $num` >> $console_file 2>&1 &
	;;
    *)
	echo "Usage: $0 seq|layout|log instance-number"
	exit 1
esac

pid=$!
echo $pid > $pid_path

exit 0

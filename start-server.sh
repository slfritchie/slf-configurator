#!/bin/sh

env="$1"
type="$2"
num="$3"

source $env
source ./corfu-cluster.sh

out_dir=$CORFU_LOG_DIR/console
mkdir -p $out_dir
pid_dir=$CORFU_LOG_DIR/console
mkdir -p $pid_dir
case $type in
    seq*)
	`corfu_fmt_sequencer_cmd 1` > $out_dir/seq.$num 2>&1 &
	;;
    lay*)
	`corfu_fmt_layout_cmd 1` > $out_dir/layout.$num 2>&1 &
	;;
    log*)
	`corfu_fmt_log_cmd 1` > $out_dir/log.$num 2>&1 &
	;;
    *)
	echo "Usage: $0 seq|layout|log instance-number"
	exit 1
esac

pid=$!
echo $pid > $pid_dir/$type.$num

exit 0

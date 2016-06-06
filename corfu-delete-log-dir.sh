#!/bin/sh

env="$1"
type="$2"
num="$3"

source $env
source ./corfu-cluster.sh

log_dir=`corfu_fmt_log_path $type $num`
rm -rf $log_dir

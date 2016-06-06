#!/bin/sh

env="$1"
type="$2"
num="$3"

source $env
source ./corfu-cluster.sh

console_dir=`corfu_fmt_console_path $type $num`
rm -rf $console_dir

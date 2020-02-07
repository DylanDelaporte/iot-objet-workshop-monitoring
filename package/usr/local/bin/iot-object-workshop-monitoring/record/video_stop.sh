#!/bin/bash
#
# video_stop: stops video_start script process
# Author: Dylan Delaporte
# Github: https://github.com/DylanDelaporte

PROCESSES=$(ps aux | grep -v 'grep' | grep 'video.sh' | awk '{print $2}')

for process in $PROCESSES
do
	echo "kill video process $process"
	kill -9 "$process"
done
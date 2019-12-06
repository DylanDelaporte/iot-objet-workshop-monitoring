#!/bin/bash
#
# cameras_stop: stops cameras_start script process
# Author: Dylan Delaporte
# Github: https://github.com/DylanDelaporte

PROCESSES=$(ps aux | grep -v 'grep' | grep 'cameras_start.sh\|ffmpeg' | awk '{print $2}')

for process in $PROCESSES
do
	echo "kill camera process $process"
	kill -9 $process
done

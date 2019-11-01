#!/bin/bash

PROCESSES=$(ps aux | grep -v 'grep' | grep 'cameras_start.sh\|ffmpeg' | awk '{print $2}')

for process in $PROCESSES
do
	echo "kill camera process $process"
	kill -9 $process
done

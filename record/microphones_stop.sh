#!/bin/bash

PROCESSES=$(ps aux | grep -v 'grep' | grep 'microphone.sh' | awk '{print $2}')

for process in $PROCESSES
do
	echo "kill microphone process $process"
	kill -9 $process
done

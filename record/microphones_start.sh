#!/bin/bash

DATA_DIRECTORY=$1
TEMPORARY_DIRECTORY=$2
#PID_FILE=microphones.pid

#./killsources.sh $PID_FILE

MICROPHONES_LIST=$(arecord --list-devices | grep card | grep -v Camera | cut -c6)

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

for microphone in $MICROPHONES_LIST
do
	echo "Microphone $microphone,0"
	$DIR/microphone.sh $microphone 0 $DATA_DIRECTORY $TEMPORARY_DIRECTORY &

	#echo $! >> $PID_FILE
done

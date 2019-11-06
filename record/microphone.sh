#!/bin/bash

MICROPHONE=$1
SUB_MICROPHONE=$2

DATA_DIRECTORY=$3
TEMPORARY_DIRECTORY=$4

arecord -D plughw:$MICROPHONE,$SUB_MICROPHONE -d 1 /dev/null

ERROR_CODE=$?

if test $ERROR_CODE -eq 1
then
	exit 0
fi

while :
do
	echo "recording 10s of microphone $MICROPHONE"
	timestamp=$(date +%s)
	current_date=$(date '+%Y-%m-%d_%H-%M-%S')
	file=${MICROPHONE}_${current_date}_10_audio.wav

	arecord -D plughw:$MICROPHONE,$SUB_MICROPHONE -d 10 -c 1 -f cd $TEMPORARY_DIRECTORY/$file
	mv $TEMPORARY_DIRECTORY/$file $DATA_DIRECTORY
done

#!/bin/bash
#
# microphone: for one specified microphone (in parameter) records in loop 10s of audio data
# Author: Dylan Delaporte
# Github: https://github.com/DylanDelaporte

#constants
MICROPHONE=$1
SUB_MICROPHONE=$2

MICROPHONE_USB_NAME=$3

DATA_DIRECTORY=$4
TEMPORARY_DIRECTORY=$5

#check if the microphone is available by recording a short audio file
arecord -D plughw:$MICROPHONE,$SUB_MICROPHONE -d 1 /dev/null

ERROR_CODE=$?

if test $ERROR_CODE -eq 1
then
	exit 0
fi

#loop
while :
do
	echo "recording 10s from microphone $MICROPHONE"

	#audio filename
	current_date=$(date '+%Y-%m-%d_%H-%M-%S')
	file=${MICROPHONE_USB_NAME}_${current_date}_10_audio.wav

	#to avoid corrupted file use of a temporary directory
	arecord -D plughw:$MICROPHONE,$SUB_MICROPHONE -d 10 -c 1 -f cd $TEMPORARY_DIRECTORY/$file
	mv $TEMPORARY_DIRECTORY/$file $DATA_DIRECTORY
done

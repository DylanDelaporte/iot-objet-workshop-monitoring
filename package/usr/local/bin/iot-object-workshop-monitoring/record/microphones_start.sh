#!/bin/bash
#
# microphones_start: find microphones then start recording audio files
# Author: Dylan Delaporte
# Github: https://github.com/DylanDelaporte

#constants
DATA_DIRECTORY=$1
TEMPORARY_DIRECTORY=$2

#the command arecord provides necessary information to find out connected microphones
MICROPHONES_LIST=$(arecord --list-devices | grep card | grep -v Camera)

#script path
DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

IFS=$'\n'

for microphone_line in $MICROPHONES_LIST
do
  #microphone id helps to figure out which microphone was recording the audio,
  #they are identified by the USB port name
  microphone_id=$(echo "$microphone_line" | awk '{print substr($2, 1, length($2) - 1)}')
  microphone_name=$(echo "$microphone_line" | awk '{print $3}')

  microphone_usb_name=$(awk '/'"$microphone_name"'[ ]*\]/{getline; print substr($3, 1, length($3) - 1)}' /proc/asound/cards)

	echo "Microphone [$microphone_name] from $microphone_usb_name has connection id: $microphone_id,0"
	"$DIR"/microphone.sh "$microphone_id" 0 "$microphone_usb_name" "$DATA_DIRECTORY" "$TEMPORARY_DIRECTORY" &
done

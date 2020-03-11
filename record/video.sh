#!/bin/bash
#
# video: record in loop for one camera
# Author: Dylan Delaporte
# Github: https://github.com/DylanDelaporte

#constant
DATA_DIRECTORY=$1
TEMPORARY_DIRECTORY=$2

CAMERA=$3
CAMERA_USB_NAME=$4

#loop
while :
do
	echo "recording 30s from camera $CAMERA"

	current_date=$(date '+%Y-%m-%d_%H-%M-%S')
	file=${CAMERA_USB_NAME}_${current_date}_30_video.mp4

	ffmpeg -f v4l2 -framerate 30 -s 1280x720 -pixel_format yuyv422\
	-i "$CAMERA" -c libx264 -crf 30 -filter:v fps=fps=5\
	-flags +global_header -t 00:00:30 "$TEMPORARY_DIRECTORY/$file"

	mv "$TEMPORARY_DIRECTORY/$file" "$DATA_DIRECTORY"
done
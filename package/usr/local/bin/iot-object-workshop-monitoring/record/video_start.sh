#!/bin/bash
#
# video_start: detect plugged cameras then start taking videos each minute
# Author: Dylan Delaporte
# Github: https://github.com/DylanDelaporte

#constant
DATA_DIRECTORY=$1
TEMPORARY_DIRECTORY=$2

#script path
DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

#list cameras
for camera in $(ls /dev/video*);
do
  [[ -e "$camera" ]] || break

	camera_usb_name=$(v4l2-ctl --list-devices | awk -v VAR="$camera" '$1 ~ VAR {print f}{f=$NF}' | sed 's/[():]//g')

	if echo "$camera_usb_name" | grep "usb"; then
	  echo "Video from camera '$camera' with usb name '$camera_usb_name'";

	  #ffmpeg -f v4l2 -framerate 30 -s 1280x720 -pixel_format yuyv422 -i "$camera" \
	  #-c libx264 -crf 30 -filter:v fps=fps=5 -flags +global_header -f segment -segment_time 60 \
	  #-segment_format_options movflags=+faststart -reset_timestamps 1 \
	  #-strftime 1 "${DATA_DIRECTORY}/${camera_usb_name}_%Y-%m-%d_%H-%M-%S_video.mp4" &

	  #ffmpeg -f v4l2 -framerate 30 -s 1280x720 -pixel_format yuyv422 -i "/dev/video0" -c libx264 -crf 30 -filter:v fps=fps=5 -flags +global_header -t 00:00:30 -strftime 1 "%Y-%m-%d_%H-%M-%S_video.mp4"

	  echo "Camera '$camera' usb name '$camera_usb_name'"
	  "$DIR"/video.sh "$DATA_DIRECTORY" "$TEMPORARY_DIRECTORY" "$camera" "$camera_usb_name" &
	fi
done
#!/bin/bash
#
# video_start: detect plugged cameras then start taking videos each minute
# Author: Dylan Delaporte
# Github: https://github.com/DylanDelaporte

#constant
DATA_DIRECTORY=$1

#list cameras
for camera in $(ls /dev/video*);
do
	echo "Video from camera '$camera'";

	ffmpeg -f v4l2 -framerate 30 -s 1280x720 -pixel_format yuyv422 -i "$camera" \
	-c libx264 -crf 30 -filter:v fps=fps=5 -flags +global_header -f segment -segment_time 60 \
	-segment_format_options movflags=+faststart -reset_timestamps 1 \
	-strftime 1 "${DATA_DIRECTORY}/${camera}_%Y-%m-%d_%H-%M-%S_video.mp4"
done
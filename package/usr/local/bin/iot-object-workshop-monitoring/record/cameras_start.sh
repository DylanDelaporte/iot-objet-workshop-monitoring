#!/bin/bash
#
# cameras_start: detect plugged cameras then start taking photos each second
# Author: Dylan Delaporte
# Github: https://github.com/DylanDelaporte

#constant
DATA_DIRECTORY=$1

#list cameras
for camera in $(ls /dev/video*);
do
	echo "Camera '$camera'";

	#one frame per second into a jpg file named with current timestamp
	ffmpeg -f v4l2 -i "$camera" -vf fps=1 -strftime 1 "${DATA_DIRECTORY}/${camera}_%Y-%m-%d_%H-%M-%S_image.jpg"
done

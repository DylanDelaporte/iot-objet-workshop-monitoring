#!/bin/bash

DATA_DIRECTORY=$1
#PID_FILE=cameras.pid

#./killsources.sh $PID_FILE

#list cameras

for camera in $(ls /dev/video*);
do
	echo "Camera '$camera'";
	
	#ffmpeg -f v4l2 -i $camera -vf fps=1 $DATA_PATH/image%d.jpg &
	ffmpeg -f v4l2 -i "$camera" -vf fps=1 -strftime 1 "${DATA_DIRECTORY}/${camera}_%Y-%m-%d_%H-%M-%S_image.jpg"

	#echo $! >> $PID_FILE
done

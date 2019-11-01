#!/bin/bash

DIR=/media/pi

FILE_TO_COPY=server.url
DESTINATION_DIR=/home/pi/research/object

COUNT_DIRS=$(ls -1 ${DIR} | wc -l)

if [ "$COUNT_DIRS" -eq 0 ]
then
	echo "There is no dirs"
	exit 1
fi

while :
do
	echo "checking if file exists within directories of $DIR"

	DIRS=$(ls -1 -d ${DIR}/*)

	for directory in $DIRS
	do
		filepath=$directory/$FILE_TO_COPY

		if [ -f "$filepath" ]; then
			echo "file on $directory directory"
			cp "$filepath" $DESTINATION_DIR
		fi
	done

	sleep 10s
done
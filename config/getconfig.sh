#!/bin/bash

DIR=/media/pi

FILE_TO_COPY=soft-config.yml
DESTINATION_DIR=/usr/local/bin/monitoring-sd

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

			systemctl restart monitoring-sd
		fi
	done

	sleep 10s
done
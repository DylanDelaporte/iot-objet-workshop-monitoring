#!/bin/bash

LOG_FILE=/var/log/monitoring-sd-config.log
CACHE_FILE=/tmp/monitoring-sd-config.cache

DIR=/media/pi

FILE_TO_COPY=soft-config.yml
DESTINATION_DIR=/usr/local/bin/monitoring-sd

touch $CACHE_FILE

while :
do
	echo "checking if file exists within directories of $DIR" >> $LOG_FILE

	COUNT_DIRS=$(ls -1 ${DIR} | wc -l)

  if [ "$COUNT_DIRS" -eq 0 ]
  then
    echo "There is no dirs" >> $LOG_FILE
    exit 1
  fi

	DIRS=$(ls -1 -d ${DIR}/*)
	OLD_DIRS=$(cat $CACHE_FILE)

	for directory in $DIRS
	do
	  EXPLORED_DIRECTORY=$(echo "$OLD_DIRS" | grep "${directory}$")

	  echo "test: '$EXPLORED_DIRECTORY'" >> $LOG_FILE

	  if [ -z "$EXPLORED_DIRECTORY" ]
	  then
      filepath=$directory/$FILE_TO_COPY

      if [ -f "$filepath" ]; then
        echo "file on $directory directory" >> $LOG_FILE
        cp "$filepath" $DESTINATION_DIR

        systemctl restart monitoring-sd
      fi
    fi
	done

	echo "$DIRS" > $CACHE_FILE

	sleep 10s
done
#!/bin/bash
#
# getconfig: retrieve soft-config.yml from plugged USB key
# Author: Dylan Delaporte
# Github: https://github.com/DylanDelaporte

#constants, modify only if needed
LOG_FILE=/var/log/monitoring-sd-config.log
CACHE_FILE=/tmp/monitoring-sd-config.cache

DIR=/media/pi

FILE_TO_COPY=soft-config.yml
DESTINATION_DIR=/usr/local/bin/iot-object-workshop-monitoring

touch $CACHE_FILE

#every 10 seconds check for new USB keys
while :
do
	echo "checking if file exists within directories of $DIR" >> $LOG_FILE

	COUNT_DIRS=$(ls -1 ${DIR} | wc -l)

  if [ "$COUNT_DIRS" -eq 0 ]
  then
    echo "There is no dirs" >> $LOG_FILE
    echo "" > $CACHE_FILE
  else
    DIRS=$(ls -1 -d ${DIR}/*)
    OLD_DIRS=$(cat $CACHE_FILE)

    for directory in $DIRS
    do
      EXPLORED_DIRECTORY=$(echo "$OLD_DIRS" | grep "${directory}$")

      #copy the file only one time from the USB, check if the key has alreay been explored previously
      if [ -z "$EXPLORED_DIRECTORY" ]
      then
        echo "exploring $directory" >> $LOG_FILE

        filepath=$directory/$FILE_TO_COPY

        if [ -f "$filepath" ]; then
          echo "file in $directory directory" >> $LOG_FILE
          cp "$filepath" $DESTINATION_DIR

          #when the file is found, restart the service
          systemctl restart monitoring-sd
        fi
      else
        echo "$directory already explored previously" >> $LOG_FILE
      fi
    done

    echo "$DIRS" > $CACHE_FILE
  fi

	sleep 10s
done
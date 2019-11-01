#!/bin/bash

if [ "$#" -ne 3 ]; then
	echo "Missing arguments"
	exit 1
fi

DATA_DIRECTORY=$1
BACKUP_DIRECTORY=$2
TEMPORARY_DIRECTORY=$3

COUNT_FILES=$(ls -1 $DATA_DIRECTORY | wc -l)

if [ "$COUNT_FILES" == "0" ]; then
	echo "No files to zip"
	exit 1
fi

DATE=$(date +%s)

OUT_FILE=out_$DATE.txt
ZIP_FILE=backup_$DATE.zip

ls -A1 $DATA_DIRECTORY/* > $OUT_FILE

zip $TEMPORARY_DIRECTORY/$ZIP_FILE -@ < $OUT_FILE
mv $TEMPORARY_DIRECTORY/$ZIP_FILE $BACKUP_DIRECTORY

while IFS= read -r line
do
	echo "backed up file $line"
	rm $line
	
	#mv $line /home/pi/research/test_output
done < "$OUT_FILE"

#cp $BACKUP_PATH/backup_$DATE.zip /home/pi/research/test_output

rm $OUT_FILE

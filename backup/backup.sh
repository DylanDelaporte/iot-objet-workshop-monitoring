#!/bin/bash
#
# backup: zip all files whithin a directory
# Author: Dylan Delaporte
# Github: https://github.com/DylanDelaporte

if [ "$#" -ne 3 ]; then
	echo "Missing arguments"
	exit 1
fi

#constants
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

#zipping files takes time, to avoid any corrupted file the file is first saved into a temporary directory
#then moved to the right place
zip $TEMPORARY_DIRECTORY/$ZIP_FILE -@ < $OUT_FILE
mv $TEMPORARY_DIRECTORY/$ZIP_FILE $BACKUP_DIRECTORY

#remove zipped files from directory
while IFS= read -r line
do
	echo "file $line saved into zip, now removing from directory"
	rm $line
done < "$OUT_FILE"

rm $OUT_FILE

#!/bin/bash

PACKAGE_NAME="package"

SERVICE_DIR="$PACKAGE_NAME/etc/systemd/system"
BIN_DIR="$PACKAGE_NAME/usr/local/bin/iot-object-workshop-monitoring"

mkdir -p $PACKAGE_NAME

cp DEBIAN/ $PACKAGE_NAME

mkdir -p $SERVICE_DIR
cp service/* $SERVICE_DIR

mkdir -p $BIN_DIR
cp backup/ $BIN_DIR
cp config/ $BIN_DIR
cp record/ $BIN_DIR
cp launcher.py $BIN_DIR
cp hard-config.yml $BIN_DIR
cp soft-config.yml $BIN_DIR

dpkg-deb --build $PACKAGE_NAME

rm -r $PACKAGE_NAME
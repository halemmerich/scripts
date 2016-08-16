#!/bin/bash
set -e

#TODO better parameter check
#TODO add parameters for keyfile/headerfile or working directory

if [ $# -eq 0 ]
then
	echo blockdevice needs to be given as first parameter, devicemapper name is an optional second parameter
	exit 1
fi

if [ $# -gt 0 ]
then
	BLOCKDEVICE="$1"
fi

. lib.sh

DEVICEID=$(getDeviceId $BLOCKDEVICE)

echo "Using device id: $DEVICEID"

if [ $# -gt 1 ]
then
	DMNAME="$2"
else
	DMNAME="$DEVICEID"
fi

echo "Using device mapper name: $DMNAME"

KEYFILE="keyfile_$DEVICEID"
HEADERFILE="luksHeader_$DEVICEID"

if [ -e $KEYFILE ]
then
	echo "The key file exists... aborting"
	exit 1
fi
if [ -e $HEADERFILE ]
then
	echo "The header file exists... aborting"
	exit 1
fi

echo Creating keyfile $KEYFILE, headerfile $HEADERFILE and encrypting blockdevice $BLOCKDEVICE.

read -p "Continue? [y/n] " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	dd if=/dev/urandom bs=8192 count=1 of="$KEYFILE"
	dd if=/dev/zero bs=1049600 count=1 of="$HEADERFILE"
	cryptsetup luksFormat --header "$HEADERFILE" --key-file "$KEYFILE" --align-payload 0 $BLOCKDEVICE
fi


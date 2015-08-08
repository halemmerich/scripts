#!/bin/bash
set -e

#TODO better parameter check
#TODO add optional parameter for working dir or keyfile/headerfile

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

cryptsetup luksOpen --key-file $KEYFILE --header $HEADERFILE $BLOCKDEVICE $DMNAME

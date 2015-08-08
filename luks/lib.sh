#!/bin/bash

function getDeviceId {
	local DISKID=$(smartctl -i $1 | grep WWN | cut -d ':' -f 2 | sed 's/ //g')
	local DISKID_TYPE=none

	if [ -z "$DISKID" ]
	then
		DISKID="$(smartctl -i $1 | grep Serial | cut -d ':' -f 2 | sed 's/ //g')"
		DISKID_TYPE=serial
	else
		DISKID_TYPE=wwn
	fi
	
	echo "${DISKID_TYPE}_$DISKID"
}

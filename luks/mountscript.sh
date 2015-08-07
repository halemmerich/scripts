set -e

#TODO add parameter check
#TODO add optional parameter for working dir or keyfile/headerfile
#TODO parametrize file system mounting

WWN=$(smartctl -i $1 | grep WWN | cut -d ':' -f 2 | sed 's/ //g')
KEYFILE="keyfile_wwn_$WWN"
HEADERFILE="luksHeader_wwn_$WWN"
DMNAME="$2"

cryptsetup luksOpen --key-file $KEYFILE --header $HEADERFILE $1 $DMNAME
btrfs device scan
mount -o noatime,autodefrag "/dev/mapper/$DMNAME" /media/backup

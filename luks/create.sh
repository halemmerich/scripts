set -e

#TODO add parameter check
#TODO add parameters for keyfile/headerfile or working directory
#TODO parametrize file system type

BLOCKDEVICE="$1"
WWN=$(smartctl -i $BLOCKDEVICE | grep WWN | cut -d ':' -f 2 | sed 's/ //g')
KEYFILE="keyfile_wwn_$WWN"
HEADERFILE="luksHeader_wwn_$WWN"
DMNAME="$2"

dd if=/dev/random bs=8192 count=1 of=$KEYFILE
dd if=/dev/zero bs=1049600 count=1 of=$HEADERFILE
cryptsetup luksFormat --header $HEADERFILE --key-file $KEYFILE --align-payload 0 $BLOCKDEVICE
cryptsetup open $BLOCKDEVICE --header $HEADERFILE --key-file $KEYFILE $DMNAME
mkfs.btrfs "/dev/mapper/$DMNAME"

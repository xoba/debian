#!/bin/bash

VMNAME=na
RUN=boot.sh

options=':n:r:help'
while getopts $options option
do
    case $option in
        n  )    VMNAME=$OPTARG;;
        r  )    RUN=$OPTARG;;
	h  )    echo "./buildrclocal.sh -n <vmname> -r <boot script>"; exit;;
    esac
done

IPADDR=`hostname -I | head -1`
sed s/IPADDR/$IPADDR/g rc.local | sed s/NAME/$VMNAME/g | sed -e "/RUN/ {
r $RUN
d }" > /tmp/rc.local
chmod u+x /tmp/rc.local
sudo cp /tmp/rc.local cd
rm /tmp/rc.local

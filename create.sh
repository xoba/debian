#!/bin/bash

VMNAME=test
MEMORY=8192
CPUS=4
RUN=boot.sh
DISK=40960

options=':n:m:c:r:d:help'
while getopts $options option
do
    case $option in
        n  )    VMNAME=$OPTARG;;
        m  )    MEMORY=$OPTARG;;
        c  )    CPUS=$OPTARG;;
        r  )    RUN=$OPTARG;;
        d  )    DISK=$OPTARG;;
	h  )    echo "./vbox.sh -n <vmname> -m <memory> -c <cpus> -r <boot script> -d <mb of disk>"; exit;;
    esac
done

# get the o/s
./downloados.sh

# build custom iso
./buildiso.sh -n $VMNAME -r $RUN

# create the virtualbox instance
./vbox.sh -n $VMNAME -m $MEMORY -c $CPUS

# dvd drive
vboxmanage storagectl $VMNAME --name "IDE" --add ide
vboxmanage storageattach $VMNAME --storagectl "IDE" --type dvddrive --port 0 --device 0 --medium `pwd`/custom.iso

mkdir -p disks

# hard drive
vboxmanage storagectl $VMNAME --name "SATA" --add sata
vboxmanage createhd --filename disks/$VMNAME.vdi --size $DISK
vboxmanage storageattach $VMNAME --storagectl "SATA" --port 0 --device 0 --type hdd --medium disks/$VMNAME.vdi

# start it
vboxmanage startvm $VMNAME --type headless

go run master.go -halt=false

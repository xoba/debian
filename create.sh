#!/bin/bash

VMNAME=test
MEMORY=8192
CPUS=4

options=':n:m:c:help'
while getopts $options option
do
    case $option in
        n  )    VMNAME=$OPTARG;;
        m  )    MEMORY=$OPTARG;;
        c  )    CPUS=$OPTARG;;
	h  )    echo "./vbox.sh -n <vmname> -m <memory> -c <cpus>"; exit;;
    esac
done

# get the o/s
./downloados.sh

# build custom iso
./buildiso.sh -n $VMNAME

# create the virtualbox instance
./vbox.sh -n $VMNAME -m $MEMORY -c $CPUS

# dvd drive
vboxmanage storagectl $VMNAME --name "IDE" --add ide
vboxmanage storageattach $VMNAME --storagectl "IDE" --type dvddrive --port 0 --device 0 --medium `pwd`/custom.iso

# hard drive
vboxmanage storagectl $VMNAME --name "SATA" --add sata
vboxmanage createhd --filename /big/$VMNAME.vdi --size 40960
vboxmanage storageattach $VMNAME --storagectl "SATA" --port 0 --device 0 --type hdd --medium /big/$VMNAME.vdi

# start it
vboxmanage startvm $VMNAME --type headless

go run master.go -halt=false

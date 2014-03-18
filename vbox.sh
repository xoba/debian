#!/bin/bash
#
# run as "./vbox.sh name memory cpus"
#

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

vboxmanage createvm -name $VMNAME --register

# configure the machine
vboxmanage modifyvm $VMNAME --memory $MEMORY
vboxmanage modifyvm $VMNAME --cpus $CPUS --ioapic on
vboxmanage modifyvm $VMNAME --ostype Debian_64
vboxmanage modifyvm $VMNAME --vram 17
vboxmanage modifyvm $VMNAME --rtcuseutc on
vboxmanage modifyvm $VMNAME --pae on
vboxmanage modifyvm $VMNAME --hpet on
vboxmanage modifyvm $VMNAME --nestedpaging on
vboxmanage modifyvm $VMNAME --largepages on
vboxmanage modifyvm $VMNAME --vtxvpid on
vboxmanage modifyvm $VMNAME --vtxux on
vboxmanage modifyvm $VMNAME --nic1 bridged --bridgeadapter1 eth1
vboxmanage modifyvm $VMNAME --nictype1 82545EM

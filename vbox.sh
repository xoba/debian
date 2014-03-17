#!/bin/bash
#
# run as "./vbox.sh name memory cpus"
#
vboxmanage createvm -name $1 --register

# configure the machine
vboxmanage modifyvm $1 --memory $2
vboxmanage modifyvm $1 --cpus $3 --ioapic on
vboxmanage modifyvm $1 --ostype Debian_64
vboxmanage modifyvm $1 --vram 17
vboxmanage modifyvm $1 --rtcuseutc on
vboxmanage modifyvm $1 --pae on
vboxmanage modifyvm $1 --hpet on
vboxmanage modifyvm $1 --nestedpaging on
vboxmanage modifyvm $1 --largepages on
vboxmanage modifyvm $1 --vtxvpid on
vboxmanage modifyvm $1 --vtxux on
vboxmanage modifyvm $1 --nic1 bridged --bridgeadapter1 eth1
vboxmanage modifyvm $1 --nictype1 82545EM

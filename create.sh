#!/bin/bash
#
# run as "./create vmname"
#

# get the o/s
./downloados.sh

# build custom iso
./buildiso.sh $1

# create the virtualbox instance
./vbox.sh $1 8192 4

# dvd drive
vboxmanage storagectl $1 --name "IDE" --add ide
vboxmanage storageattach $1 --storagectl "IDE" --type dvddrive --port 0 --device 0 --medium `pwd`/custom.iso

# hard drive
vboxmanage storagectl $1 --name "SATA" --add sata
vboxmanage createhd --filename /big/$1.vdi --size 40960
vboxmanage storageattach $1 --storagectl "SATA" --port 0 --device 0 --type hdd --medium /big/$1.vdi

# start it
vboxmanage startvm $1 --type headless

go run master.go -halt false

#!/bin/bash
vboxmanage createvm -name $1 --register

# configure the machine
vboxmanage modifyvm $1 --ostype Debian_64
vboxmanage modifyvm $1 --memory 8192
vboxmanage modifyvm $1 --vram 17
vboxmanage modifyvm $1 --cpus 4 --ioapic on
vboxmanage modifyvm $1 --rtcuseutc on
vboxmanage modifyvm $1 --pae on
vboxmanage modifyvm $1 --nestedpaging on
vboxmanage modifyvm $1 --largepages on
vboxmanage modifyvm $1 --vtxvpid on
vboxmanage modifyvm $1 --nic1 bridged --bridgeadapter1 eth1
vboxmanage modifyvm $1 --nictype1 82545EM

# dvd drive
vboxmanage storagectl $1 --name "IDE" --add ide
wget http://cdimage.debian.org/cdimage/daily-builds/daily/arch-latest/amd64/iso-cd/debian-testing-amd64-netinst.iso
VBoxManage storageattach $1 --storagectl "IDE" --type dvddrive --port 0 --device 0 --medium /home/mra/Desktop/debian-testing-amd64-netinst.iso

# hard drive
vboxmanage storagectl $1 --name "SATA" --add sata
VBoxManage createhd --filename /big/$1.vdi --size 40960
vboxmanage storageattach $1 --storagectl "SATA" --port 0 --device 0 --type hdd --medium /big/$1.vdi

# start it
vboxmanage startvm $1

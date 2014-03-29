#!/bin/bash

#
# play around creating a simple o/s from scratch
#

./vbox.sh -n os -m 4096 -c 2
nasm boot_sect.asm -f bin -o boot_sect.img

vboxmanage storagectl os --name "boot" --add floppy
vboxmanage storageattach os --storagectl "boot" --type fdd --port 0 --device 0 --medium `pwd`/boot_sect.img

vboxmanage startvm os

exit

./poweroff.sh os
./destroy.sh os

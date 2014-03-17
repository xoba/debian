#!/bin/bash
wget -N http://cdimage.debian.org/cdimage/daily-builds/daily/arch-latest/amd64/iso-cd/debian-testing-amd64-netinst.iso
wget -N http://cdimage.debian.org/cdimage/daily-builds/daily/arch-latest/amd64/iso-cd/MD5SUMS.small
export OK=`md5sum -c MD5SUMS.small | grep "OK" | wc -l`
if [ $OK != 1 ]
then
    echo "bad md5sum for debian-testing-amd64-netinst.iso"
    exit
fi

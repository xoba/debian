#!/bin/bash

# following https://wiki.debian.org/DebianInstaller/Preseed/EditIso on 2014-03-16

if [ -d cd ]
then
    chmod -R 777 cd
    rm -rf cd
fi

mkdir loopdir
fuseiso debian-testing-amd64-netinst.iso loopdir
mkdir cd
sleep 1
rsync -a -H --exclude=TRANS.TBL loopdir/ cd
fusermount -u loopdir
rm -rf loopdir

chmod -R u+w cd

rm -rf irmod
mkdir irmod
cd irmod
gzip -d < ../cd/install.amd/initrd.gz | cpio --extract --make-directories --no-absolute-filenames
cp ../preseed.cfg preseed.cfg
find . | cpio -H newc --create | gzip -9 > ../cd/install.amd/initrd.gz
cd ../
rm -fr irmod/

cd cd
cat > isolinux/isolinux.cfg <<EOF
prompt 0
timeout 1
default install
label install
	menu label ^Install
	menu default
	kernel /install.amd/vmlinuz
	append vga=788 initrd=/install.amd/initrd.gz -- quiet 
EOF
md5sum `find -follow -type f` > md5sum.txt
cd ..

mkisofs -o preseeded.iso -r -J -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux/isolinux.bin -c isolinux/boot.cat ./cd


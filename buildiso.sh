#!/bin/bash

sudo rm -rf cd loopdir irmod

sudo mkdir loopdir
sudo mount -r -o loop debian-testing-amd64-netinst.iso loopdir
mkdir cd
rsync -a -H --exclude=TRANS.TBL loopdir/ cd
sudo umount loopdir
rm -rf loopdir

sed s/NAME/$1/g rc.local > /tmp/rc.local
sudo cp /tmp/rc.local cd/
rm /tmp/rc.local
sudo chmod -R u+w cd

sudo chmod uog+x cd/rc.local

mkdir irmod
cd irmod
gzip -d < ../cd/install.amd/initrd.gz | sudo cpio --extract --make-directories --no-absolute-filenames
cp ../preseed.cfg preseed.cfg
find . | cpio -H newc --create | gzip -9 > ../cd/install.amd/initrd.gz
cd ../
sudo rm -rf irmod

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
md5sum `find -L . -type f` > md5sum.txt
cd ..

sudo chown -R root cd
sudo chgrp -R root cd

sudo genisoimage -quiet -o custom.iso -r -J -l -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux/isolinux.bin -z -iso-level 4 -c isolinux/boot.cat ./cd


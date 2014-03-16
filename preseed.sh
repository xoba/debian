#!/bin/bash

mkdir -p loopdir
fuseiso debian-testing-amd64-netinst.iso loopdir
mkdir -p cd
rsync -a -H --exclude=TRANS.TBL loopdir/ cd
fusermount -u loopdir
rmdir loopdir



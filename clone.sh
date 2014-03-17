#!/bin/bash
export SNAP="snap`uuidgen`"
vboxmanage snapshot $1 take $SNAP
vboxmanage clonevm $1 --register --snapshot $SNAP --options link --name $2 




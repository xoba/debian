#!/bin/bash
export SNAP="snap`uuidgen`"
vboxmanage snapshot testing take $SNAP
vboxmanage clonevm $1 --snapshot $SNAP --options link --name $2 --register




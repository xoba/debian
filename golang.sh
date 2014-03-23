#!/bin/bash

# build golang if it doesn't already exist

if [ -d /root/go ]; 
then 
    cd /root
    source <(curl https://raw.github.com/xoba/goinit/master/buildgo.sh) 2>&1 | tee golog.txt
fi

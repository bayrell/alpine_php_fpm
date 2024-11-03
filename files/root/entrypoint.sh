#!/bin/bash

if [ "$@" = "/root/run.sh" ]; then
    sudo -u root -i /root/run.sh
else
    eval $@
fi

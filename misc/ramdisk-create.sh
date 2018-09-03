#!/bin/bash -x

DIR='/var/www/ramdisk'

[ ! -d $DIR ] && mkdir $DIR

LINE="tmpfs $DIR tmpfs nodev,nosuid,size=1M 0 0"

echo $LINE | sudo tee --append /etc/fstab

sudo mount -a

df

#!/bin/bash

# for using `service start portier`
# cat /lib/systemd/system/portier.service
#[Unit]
#Description=Portier
#After=multi-user.target
#
#[Service]
#Type=simple
#ExecStart=/home/pi/portier/misc/service.sh
#Restart=on-abort
#
#[Install]
#WantedBy=multi-user.target

WWW=/var/www/ramdisk/around_home
BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )
PROJECT_DIR="$BASE_DIR/.."


cp $PROJECT_DIR/www/pages/suresnes.html $WWW/

$PROJECT_DIR/update.sh --daemon --index=$WWW/index.html --dir=$WWW/suresnes.html

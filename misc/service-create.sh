#!/bin/bash -x

read -r -d '' CONFIG <<- EOM
[Unit]
Description=Portier
After=multi-user.target

[Service]
Type=simple
ExecStart=/home/${USER}/portier/misc/service.sh
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOM

echo $CONFIG | sudo tee --append /lib/systemd/system/portier.service

service portier start

#!/bin/bash -x

read -d '' CONFIG <<- EOM
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

echo "$CONFIG" | sudo tee /lib/systemd/system/portier.service

sudo chmod +x /lib/systemd/system/portier.service

sudo systemctl enable portier
sudo service portier start

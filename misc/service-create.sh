#!/bin/bash -x

read -d '' CONFIG <<- EOM
[Unit]
Description=Portier
After=multi-user.target

[Install]
WantedBy=multi-user.target

[Service]
Type=simple
User=${USER}
Restart=always
RemainAfterExit=yes
ExecStart=/home/${USER}/portier/misc/service.sh
EOM

echo "$CONFIG" | sudo tee /lib/systemd/system/portier.service

sudo systemctl enable portier
sudo systemctl daemon-reload
sudo systemctl restart portier

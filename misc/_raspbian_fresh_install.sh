#!/bin/bash

cd /home/${USER}/

curl -sSL -D - 'https://github.com/1e1/portier/archive/master.tar.gz' -o portier-master.tar.gz
tar -xzf portier-master.tar.gz
rm portier-master.tar.gz

cd portier-master
ls -al


bash ./misc/_install_core.sh
bash ./misc/_install_webserver.sh

#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )
PROJECT_DIR="$BASE_DIR/.."


sudo apt-get update
#sudo apt-get install -y python3-pip

#sudo -H pip3 install -U -r $PROJECT_DIR/requirements.txt


sudo apt-get install -y python3-lxml python3-requests


bash $BASE_DIR/ramdisk-create.sh
bash $BASE_DIR/service-create.sh

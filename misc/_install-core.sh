#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )
PROJECT_DIR="$BASE_DIR/.."


sudo apt-get update
sudo apt-get install -y python3-pip


pip3 install -r $PROJECT_DIR/requirements.txt


$BASE_DIR/ramdisk-create.sh
$BASE_DIR/service-create.sh

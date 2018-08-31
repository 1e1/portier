#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )


$BASE_DIR/ramdisk-create.sh
$BASE_DIR/nginx-copy-conf.sh
$BASE_DIR/service-create.sh

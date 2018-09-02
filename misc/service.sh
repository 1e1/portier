#!/bin/bash -x

WWW=/var/www/ramdisk/around_home
BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )
PROJECT_DIR="$BASE_DIR/.."


if [ ! -d $WWW ]
then
    mkdir $WWW
fi


cp -R $PROJECT_DIR/www/assets $WWW/
cp $PROJECT_DIR/www/pages/suresnes.html $WWW/

$PROJECT_DIR/update.sh --daemon --index=$WWW/index.html --dir=$WWW/suresnes.html

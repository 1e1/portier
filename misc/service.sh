#!/bin/bash -x

WWW=/var/www/ramdisk/around_home
BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )
PROJECT_DIR="$BASE_DIR/.."


if [ ! -d $WWW ]
then
    mkdir $WWW
fi


cp -R $PROJECT_DIR/www/assets $WWW/


if [ -f $PROJECT_DIR/www/pages/index.html ]
then
    cp $PROJECT_DIR/www/pages/index.html $WWW/
    $PROJECT_DIR/update.sh --daemon --no-index --dir=$WWW/index.html

else
    cp -R $PROJECT_DIR/www/pages $WWW/
    $PROJECT_DIR/update.sh --daemon --index=$WWW/index.html --dir=$WWW/pages
fi

#!/bin/bash


TEMPLATE=All
HOME_USR="/home/${USER}"
WWW="./www/pages"


for opt in "$@"
do
  case $opt in
  --template=*)
    TEMPLATE=${opt#*=}
    ;;
  esac
done


echo '-- INSTALL PORTIER --'
echo "TEMPLATE=$TEMPLATE"
echo "HOME_USR=$HOME_USR"
echo "WWW=$WWW"
echo '---'


cd $HOME_USR

curl -sSL -D - 'https://github.com/1e1/portier/archive/master.tar.gz' -o portier.tar.gz
tar -xzf portier.tar.gz
rm portier.tar.gz

cd portier
ls -al


if [ $TEMPLATE != All ]
then
    echo 'make default webpage'
    cp $WWW/$TEMPLATE.html $WWW/index.html
fi


bash ./misc/_install-core.sh
bash ./misc/_install-webserver.sh

#!/bin/bash

# http://manpages.ubuntu.com/manpages/bionic/en/man8/start-stop-daemon.8.html

INDEX=True
DAEMON=False
SLEEP=15
BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )
WWW_DIR="$BASE_DIR/www"
INDEX_PATH="$WWW_DIR/index.html"
DIR_PATH="$WWW_DIR/pages"
SHM_PATH='/dev/shm'
WS_PATH=None
FILES=()
HTML=()
LINKS=()



[ $LC_ALL ] || export LC_ALL="fr_FR.UTF-8"
[ $LANG ] || export LANG="fr_FR.UTF-8"
[ $LANGUAGE ] || export LANGUAGE="fr_FR.UTF-8"



for opt in "$@"
do
  case $opt in
  "-s"|"--no-index")
    INDEX=False
    ;;
  "-d"|"--daemon")
    DAEMON=True
    ;;
  --sleep=*)
    SLEEP=${opt#*=}
    ;;
  --index=*)
    INDEX_PATH=${opt#*=}
    ;;
  --dir=*)
    DIR_PATH=${opt#*=}
    ;;
  --shared-memory=*)
    SHM_PATH=${opt#*=}
    ;;
  esac
done



if [ -f "$DIR_PATH" ]
then
  FILES=($DIR_PATH)
else
  FILES="$DIR_PATH/*.html"
fi



z()
{
  echo -n "sleep $1s ["

  for ((i=0;i<$1;i++))
  do 
    echo -n '#'
    sleep 1
  done
  
  echo ']'
  echo
}


x()
{
  if [ -d "$SHM_PATH" ]
  then
    WS_PATH=`mktemp -d "$SHM_PATH/portier-XXXXXX"`
    echo "WORKSPACE $WS_PATH"
  fi

  for f in $FILES
  do
    echo "MAKE $f"

    TEMP_PATH="$f.tmp"
    VIRT_PATH=$TEMP_PATH

    if [ -d $WS_PATH ]
    then
      bn=$(basename $f)
      VIRT_PATH="$WS_PATH/$bn"
    fi

    echo "WORKFILE $VIRT_PATH"
    cp "$f" "$VIRT_PATH"

    for c in $BASE_DIR/connectors/*
    do
      echo "* $c"
      $c "$VIRT_PATH"
    done

    echo "WRITE $TEMP_PATH"
    [ "$VIRT_PATH" == "$TEMP_PATH" ] || mv "$VIRT_PATH" "$TEMP_PATH"
    echo "MOVE $f"
    mv "$TEMP_PATH" "$f"
 
    echo
  done

  if [ -d $WS_PATH ]
  then
    rm -r "$WS_PATH"
  fi
}

xx()
{
  while true
  do
    x
    z $SLEEP
  done
}


echo 'links:'
INDEX_DIR=$(dirname $INDEX_PATH)
for f in $FILES
do
  LINK=$(realpath --relative-to="$INDEX_DIR" "$f")
  LINKS+=($LINK)
  echo "- $LINK"
done
echo

HTML+=('<html>')
HTML+=('<head>')
if [ ${#LINKS[@]} -gt 1 ]
then
  HTML+=('<link rel="stylesheet" href="./assets/style.css"/>')
  for l in ${LINKS[@]}
  do
    HTML+=("<link rel="preload" href='$l'/>")
    HTML+=("<link rel="prerender" href='$l'/>")
  done
else
  HTML+=("<meta http-equiv='refresh' content='0;URL=${LINK[0]}' />")
fi
HTML+=('</head>')
if [ ${#LINKS[@]} -gt 1 ]
then
  HTML+=('<body>')
  HTML+=('<section class="index">')
  for l in ${LINKS[*]}
  do
    bn=$(basename $l)
    fn=${bn%.*}
    HTML+=("<a href='$l'>$fn</a>")
  done
  HTML+=('</section>')
  HTML+=('<section class="center">')
  HTML+=($(date "+%Y-%m-%d %X"))
  HTML+=('</section>')
  HTML+=('</body>')
fi
HTML+=('</html>')



if [ $DAEMON = True ]
then
  xx
else
  x
fi

if [ $INDEX = True ]
then
  echo ${HTML[*]} > $INDEX_PATH
  echo "index: $INDEX_PATH"
  echo 
else
  echo 'index: none'
  echo
fi

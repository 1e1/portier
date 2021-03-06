#!/bin/bash

# http://manpages.ubuntu.com/manpages/bionic/en/man8/start-stop-daemon.8.html

INDEX=True
DAEMON=False
SLEEP=15
readonly BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )
readonly WWW_DIR="$BASE_DIR/www"
INDEX_PATH="$WWW_DIR/index.html"
DIR_PATH="$WWW_DIR/pages"
SHM_PATH='/dev/shm'
WS_PATH=None
FILES=()
HTML=()
LINKS=()


export PYTHONIOENCODING='utf-8'


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

if [ -d "$SHM_PATH" ]
then
  rm -rf $SHM_PATH/portier-*
  WS_PATH=`mktemp -d "$SHM_PATH/portier-XXXXXX"`
  echo "WORKSPACE $WS_PATH"
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
  for f in $FILES
  do
    echo "MAKE $f"

    TEMP_PATH="$f.tmp"

    if [ -d $WS_PATH ]
    then
      bn=$(basename $f)
      TEMP_PATH="$WS_PATH/$bn"
    fi

    echo "WORKFILE $TEMP_PATH"
    ls -l $f

    for c in $BASE_DIR/connectors/*
    do
      echo "* $c"
      $c "$f" "$TEMP_PATH"
      ls -l $TEMP_PATH

      echo "WRITE $TEMP_PATH"
      mv "$TEMP_PATH" "$f"
      ls -l $f
    done
 
    echo
  done
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
  HTML+=('<link rel="stylesheet" href="./assets/css/style.css"/>')
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



if [ -d $WS_PATH ]
then
  rm -r "$WS_PATH"
fi

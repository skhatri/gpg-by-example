#!/usr/bin/env bash

cmd=$1

if [[ ! -f /opt/app/download-${cmd}-upload.sh ]];
then 
  echo "command ${cmd} not understood"
  exit 1;
fi;

exec /opt/app/download-${cmd}-upload.sh "$@"

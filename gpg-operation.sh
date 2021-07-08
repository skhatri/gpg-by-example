#!/usr/bin/env bash

cmd=$1

if [[ "${cmd}" == "debug" ]]; then
 sleep 1d; 
else
  exec /opt/app/handler.sh "$@"
fi;



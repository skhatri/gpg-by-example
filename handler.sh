#!/usr/bin/env bash

cmd=$1

if [[ ! -f /opt/app/download-${cmd}-upload.sh ]];
then 
  echo "command ${cmd} not understood"
  exit 1;
fi;

shift 1;
/opt/app/download-${cmd}-upload.sh "$@"
exit_code=$?
result="success"
if [[ ${exit_code} -ne 0 ]];then 
    result="failure"
fi;
echo "status: ${result}"

if [[ ! -z ${WEBHOOK_URL} ]] && [[ ! -z ${WEBHOOK_NOTIFICATION_TEMPLATE} ]];
then 
    data=$(echo "${WEBHOOK_NOTIFICATION_TEMPLATE}"|sed "s/__DOWNLOAD_FILE__/${DOWNLOAD_FILE}/g;s/__UPLOAD_FILE__/${UPLOAD_FILE}/g;s/__STATUS__/${result}/g")
    curl -H"Content-Type: application/json" -sk ${WEBHOOK_URL} -d ${data}
    notification_result=$?
    if [[ $notification_result -ne 0 ]];
    then 
      echo "failed to send notification."
    fi;
fi;
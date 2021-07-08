#!/usr/bin/env bash
script_dir=$(dirname $0)
cmd=$1




_preconfigure() { 
  if [[ ! -z ${CONFIG_ENDPOINT} ]]; then 
    curl -o /tmp/config.json -sk ${CONFIG_ENDPOINT}
    : "${CONFIG_SELECTOR:=".data.configMap"}"

  fi;
}


_notify() {
    if [[ ! -z ${WEBHOOK_ENDPOINT} ]] && [[ ! -z ${WEBHOOK_NOTIFICATION_TEMPLATE} ]];
    then 
        data=$(echo "${WEBHOOK_NOTIFICATION_TEMPLATE}"|sed "s/__DOWNLOAD_FILE__/${DOWNLOAD_FILE}/g;s/__UPLOAD_FILE__/${UPLOAD_FILE}/g;s/__STATUS__/${result}/g")
        curl -H"Content-Type: application/json" -sk ${WEBHOOK_ENDPOINT} -d ${data}
        notification_result=$?
        if [[ $notification_result -ne 0 ]];
        then 
        echo "failed to send notification."
        fi;
    fi;
}


_execute() {
    if [[ ! -f ${script_dir}/download-${cmd}-upload.sh ]];
    then 
        echo "command ${cmd} not understood"
        exit 1;
    fi;
    shift 1;

    _preconfigure
    ${script_dir}/download-${cmd}-upload.sh "$@"
    exit_code=$?
    result="success"
    if [[ ${exit_code} -ne 0 ]];then 
        result="failure"
    fi;
    echo "{\"result\": \"${result}\", \"operation\":\"${cmd}\", \"download_path\":\"${DOWNLOAD_FILE}\", \"upload_path\":\"${UPLOAD_FILE}\"}"
    _notify
}


_execute

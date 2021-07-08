#!/usr/bin/env bash
script_dir=$(dirname $0)
cmd=$1




_preconfigure() { 
  if [[ ! -z ${CONFIG_ENDPOINT} ]]; then 

    if [[ -z ${EOD_DATE} ]]; then 
      echo "EOD_DATE is required."
      exit 1;
    fi;
    if [[ -z ${FREQUENCY} ]]; then 
      echo "FREQUENCY is required."
      exit 1;
    fi;

    DATE_WITH_DASH=${EOD_DATE}
    DATE_WITHOUT_DASH=$(echo "${EOD_DATE}"|sed 's/"-"//g')
    if [[ "${FREQUENCY}" == "monthly" ]]; then 
      MONTH=$(echo ${EOD_DATE}|awk -F"-" '{print $1"-"$2}')
      DATE_WITH_DASH="${MONTH}"
      DATE_WITHOUT_DASH=$(echo ${MONTH}|sed 's/"-"//g')
    fi;
    
    curl -o /tmp/config.json -sk ${CONFIG_ENDPOINT}
    : "${CONFIG_SELECTOR:=".data.configMap"}"
    for kv in $(cat /tmp/config.json|jq -r "${CONFIG_SELECTOR}"|jq -r 'to_entries|map("\(.key):::\(.value|tostring)")|.[]');
    do 
        read a b <<< $(echo $kv|awk -F":::" '{print $1" \""$2"\""}')
        value=$(echo $b|sed "s/__DATE_WITH_DASH__/${DATE_WITH_DASH}/;s/__DATE_WITHOUT_DASH__/${DATE_WITHOUT_DASH}/g;s/\"//g")
        echo config $a with value $value

        export $a=$value
        export DOWNLOAD_FILE="${BASE_S3_PATH}/${DOWNLOAD_PATH}/${DOWNLOAD_FILE_NAME}"
        export UPLOAD_FILE="${BASE_S3_PATH}/${UPLOAD_PATH}/${UPLOAD_FILE_NAME}"
    done;
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

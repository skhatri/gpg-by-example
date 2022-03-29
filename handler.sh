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
    DATE_WITHOUT_DASH=$(echo "${EOD_DATE}"|sed 's/-//g')
    if [[ "${FREQUENCY}" == "monthly" ]]; then 
      MONTH=$(echo ${EOD_DATE}|awk -F"-" '{print $1"-"$2}')
      DATE_WITH_DASH="${MONTH}"
      DATE_WITHOUT_DASH=$(echo ${MONTH}|sed 's/-//g')
    fi;
    
    curl -o /tmp/config.json -sk ${CONFIG_ENDPOINT}
    : "${CONFIG_SELECTOR:=".data.configMap"}"
    
    cat /tmp/config.json|jq -r "${CONFIG_SELECTOR}"|jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' > /tmp/vars.txt
    while IFS= read -r kv;
    do
        echo "kv is [${kv}]"
        a=$(echo $kv|awk -F"=" '{print $1}')
        b=$(echo $kv|sed 's/.*=//')
        echo "B is [${b}]"
        value=$(echo $b|sed "s/__DATE_WITH_DASH__/${DATE_WITH_DASH}/;s/__DATE_WITHOUT_DASH__/${DATE_WITHOUT_DASH}/g;s/\"//g")
        echo config $a with value $value

        export $a="$value"
    done < /tmp/vars.txt
    if [[ -n "$DOWNLOAD_BASE_S3_PATH" ]]; then
      echo "Using separate base path for download: $DOWNLOAD_BASE_S3_PATH"
      DOWNLOAD_BASE_S3_PATH="$DOWNLOAD_BASE_S3_PATH"
    else
      DOWNLOAD_BASE_S3_PATH="$BASE_S3_PATH"
    fi
    if [[ -n "$UPLOAD_BASE_S3_PATH" ]]; then
      echo "Using separate base path for upload: $UPLOAD_BASE_S3_PATH"
      UPLOAD_BASE_S3_PATH="$UPLOAD_BASE_S3_PATH"
    else
      UPLOAD_BASE_S3_PATH="$BASE_S3_PATH"
    fi
    export DOWNLOAD_FILE="${DOWNLOAD_BASE_S3_PATH}/${DOWNLOAD_PATH}/${DOWNLOAD_FILE_NAME}"
    export UPLOAD_FILE="${UPLOAD_BASE_S3_PATH}/${UPLOAD_PATH}/${UPLOAD_FILE_NAME}"
  fi;
}


_notify() {
    for var_name in $(env|grep WEBHOOK_ENDPOINT|grep -v TEMPLATE|awk -F"=" '{print $1}');
    do 
      template_name="${var_name}_TEMPLATE"
      if [[ ! -z ${!var_name} ]] && [[ ! -z ${!template_name} ]];
      then 
        template=${!template_name}
        endpoint=${!var_name}
        data=$(echo "${template}"|sed "s#__DOWNLOAD_FILE__#"${DOWNLOAD_FILE}"#g;s#__UPLOAD_FILE__#"${UPLOAD_FILE}"#g;s#__STATUS__#${result}#g")
        curl -H"Content-Type: application/json" -sk ${endpoint} -d "'"${data}"'"
        notification_result=$?
        if [[ $notification_result -ne 0 ]];
        then 
        echo "failed to send notification to ${!var_name}"
        fi;

      fi;
    done;

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

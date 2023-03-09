#!/usr/bin/env bash


if [[ -z "${S3_SECRETS_FILE}" ]] || [[ ! -f "${S3_SECRETS_FILE}" ]];
then
  echo "s3 secrets file is required. It is either the incorrect path or file is missing. Use S3_SECRETS_FILE env to provide the correct pathway to the file."
  exit 1;
fi;

access_key=$(jq -r '.accessKeyId' "${S3_SECRETS_FILE}")
secret_key=$(jq -r '.secretAccessKey' "${S3_SECRETS_FILE}")
token=$(jq -r '.sessionToken' "${S3_SECRETS_FILE}")

export AWS_ACCESS_KEY_ID=${access_key}
export AWS_SECRET_ACCESS_KEY=${secret_key}
export AWS_SESSION_TOKEN=${token}

source=$1
target=$2
download_upload=$3

_usage() {
  echo "./s3.sh <source> <target> <download/upload>"
  echo "<download/upload> optional"
}

if [[ -z ${source} ]] || [[ -z ${target} ]];
then
  _usage
  exit 1;
fi;

other_args=""
if [[ "${AWS_NO_VERIFY_SSL}" == "true" ]];
then
  echo "disabling SSL verification"
  other_args+=" --no-verify-ssl"
fi;

if [[ -n "${DOWNLOAD_AWS_ENDPOINT_URL}" && $download_upload == "download" ]];
then
  other_args+=" --endpoint-url ${DOWNLOAD_AWS_ENDPOINT_URL}"
elif [[ -n "${UPLOAD_AWS_ENDPOINT_URL}" && $download_upload == "upload" ]];
then
  other_args+=" --endpoint-url ${UPLOAD_AWS_ENDPOINT_URL}"
elif [[ -n "${AWS_ENDPOINT_URL}" ]];
then
  other_args+=" --endpoint-url ${AWS_ENDPOINT_URL}"
fi;

AWS_ACCESS_KEY_ID=${access_key} AWS_SECRET_ACCESS_KEY=${secret_key} AWS_SESSION_TOKEN=${token} \
  aws s3 cp "${source}" "${target}" ${other_args}


 

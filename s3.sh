#!/usr/bin/env bash

set -x

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

other_args=""
if [[ -n "${AWS_ENDPOINT_URL}" ]];
then
  other_args+=" --endpoint-url ${AWS_ENDPOINT_URL}"
fi;

if [[ "${AWS_NO_VERIFY_SSL}" == "true" ]];
then
  echo "disabling SSL verification"
  other_args+=" --no-verify-ssl"
fi;

source=$1
target=$2

_usage() {
  echo "./s3.sh <source> <target>"
}

if [[ -z ${source} ]] || [[ -z ${target} ]];
then
  _usage
  exit 1;
fi;

AWS_ACCESS_KEY_ID=${access_key} AWS_SECRET_ACCESS_KEY=${secret_key} AWS_SESSION_TOKEN=${token} \
  aws s3 cp "${source}" "${target}" ${other_args}


 

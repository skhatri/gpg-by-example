#!/usr/bin/env bash

if [[ -z ${S3_SECRETS_FILE} ]] || [[ ! -f ${S3_SECRETS_FILE} ]]; 
then
  echo "s3 secrets file is required. use S3_SECRETS_FILE env to provide it."
  exit 1;
fi;

access_key=$(cat ${S3_SECRETS_FILE}|jq -r '.accessKeyId')
secret_key=$(cat ${S3_SECRETS_FILE}|jq -r '.secretAccessKey')
token=$(cat ${S3_SECRETS_FILE}|jq -r '.sessionToken')

export AWS_ACCESS_KEY_ID=${access_key}
export AWS_SECRET_ACCESS_KEY=${secret_key}
export AWS_SESSION_TOKEN=${token}

other_args="--no-verify-ssl"
if [[ ! -z ${AWS_ENDPOINT_URL} ]];
then
  other_args="${other_args} --endpoint-url ${AWS_ENDPOINT_URL}"
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
aws s3 cp ${source} ${target} ${other_args}


 

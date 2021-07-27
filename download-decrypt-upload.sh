#!/usr/bin/env bash

set -e

: "${WORK_DIR:=/tmp/work-dir}"

if [[ ! -d ${WORK_DIR} ]];
then
  mkdir -p ${WORK_DIR}
fi;

if [[ -z ${DOWNLOAD_FILE} ]];
then
  echo "file to download must be specified"
  exit 1;
fi;

if [[ -z ${UPLOAD_FILE} ]];
then 
  echo "upload file must be specified"
  exit 1;
fi;

if [[ ! "${DOWNLOAD_FILE}" =~ s3://.* ]];
then
  echo "${DOWNLOAD_FILE} does not start with s3://"
  exit 1;
fi;

if [[ ! "${UPLOAD_FILE}" =~ s3://.* ]];
then 
  echo "${UPLOAD_FILE} does not start with s3://"
  exit 1;
fi;
./s3.sh ${DOWNLOAD_FILE}  ${WORK_DIR}/_encrypted_file

if [[ "${ENABLE_DECRYPTION}" = "false" ]];
then
  echo "decryption disabled"
  cp ${WORK_DIR}/_encrypted_file ${WORK_DIR}/_tmp_file
else
  ./crypto.sh decrypt ${WORK_DIR}/_encrypted_file ${WORK_DIR}/_tmp_file
fi;

./s3.sh ${WORK_DIR}/_tmp_file ${UPLOAD_FILE}

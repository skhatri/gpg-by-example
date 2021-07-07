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
./s3.sh ${DOWNLOAD_FILE}  ${WORK_DIR}/_tmpfile

./crypto.sh encrypt ${WORK_DIR}/_tmpfile ${WORK_DIR}/_encrypted_file

./s3.sh ${WORK_DIR}/_encrypted_file ${UPLOAD_FILE}

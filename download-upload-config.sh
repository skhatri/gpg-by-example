#!/usr/bin/env bash

: "${WORK_DIR:=/tmp/work-dir}"
: "${CRYPTOGRAPHY_SCRIPT:=crypto.sh}"

if [[ ! "${CRYPTOGRAPHY_SCRIPT}" == crypto.sh ]]; then
  echo "Ensure ${CRYPTOGRAPHY_SCRIPT} takes in 3 arguments: <encrypt/decrypt> <source_file> <destination_file>. Check crypto.sh as an example"
fi
export CRYPTOGRAPHY_SCRIPT=${CRYPTOGRAPHY_SCRIPT}

if [[ ! -d ${WORK_DIR} ]]; then
  mkdir -p ${WORK_DIR}
fi

if [[ -z ${DOWNLOAD_FILE} ]]; then
  echo "file to download must be specified"
  exit 1
fi

if [[ -z ${UPLOAD_FILE} ]]; then
  echo "upload file must be specified"
  exit 1
fi

if [[ ! "${DOWNLOAD_FILE}" =~ s3://.* ]]; then
  echo "${DOWNLOAD_FILE} does not start with s3://"
  exit 1
fi

if [[ ! "${UPLOAD_FILE}" =~ s3://.* ]]; then
  echo "${UPLOAD_FILE} does not start with s3://"
  exit 1
fi

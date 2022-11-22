#!/usr/bin/env bash

set -e
. ./download-upload-config.sh

./s3.sh "${DOWNLOAD_FILE}" "${WORK_DIR}"/_tmpfile

if [[ "${ENABLE_ENCRYPTION}" = "false" ]]; then
  echo "encryption disabled"
  cp "${WORK_DIR}"/_tmpfile "${WORK_DIR}"/_encrypted_file
else
  ./"${CRYPTOGRAPHY_SCRIPT}" encrypt "${WORK_DIR}"/_tmpfile "${WORK_DIR}"/_encrypted_file
fi

./s3.sh "${WORK_DIR}"/_encrypted_file "${UPLOAD_FILE}"

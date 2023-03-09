#!/usr/bin/env bash

set -e
. ./download-upload-config.sh

./s3.sh "${DOWNLOAD_FILE}" "${WORK_DIR}"/_encrypted_file download

if [[ "${ENABLE_DECRYPTION}" = "false" ]]; then
  echo "decryption disabled"
  cp "${WORK_DIR}"/_encrypted_file "${WORK_DIR}"/_tmp_file
else
  ./"${CRYPTOGRAPHY_SCRIPT}" decrypt "${WORK_DIR}"/_encrypted_file "${WORK_DIR}"/_tmp_file
fi

./s3.sh "${WORK_DIR}"/_tmp_file "${UPLOAD_FILE}" upload

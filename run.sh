#!/usr/bin/env bash 
set -e

user_dir=$1

if [[ ! -d "${user_dir}" ]]; then
  echo "user config not found"
  exit 1;
fi;


if [[ ! -d "${user_dir}/secrets" ]]; then
  mkdir -p "${user_dir}"/secrets
fi;

./create-s3-key.sh

docker run --entrypoint '/bin/bash' -v $(pwd)/tests:/tmp/tests -v $(pwd)/${user_dir}:/home/app  -v $(pwd)/pubkeys:/tmp/data -v $(pwd)/data:/data \
-it gpg



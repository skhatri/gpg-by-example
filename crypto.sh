#!/usr/bin/env bash

set -e

error() {
    local msg=$1
    echo "${msg}"
    exit 1;
}

_check_env() {
    local env_var_name=$1
    if [[ -z ${!env_var_name} ]];
    then 
      error "Env var ${env_var_name} is required."
    fi;
    if [[ ! -f ${!env_var_name} ]];
    then 
      error "${env_var_name} file ${!env_var_name} is not accessible"
    fi;
}

_check_env PASSPHRASE_FILE
_check_env OWNER_KEY_FILE
_check_env PARTNER_PUBLIC_KEY_FILE

_init_crypto() {

    if [[ -z ${OWNER_ID} ]];
    then
    error "Owner id is not set. Provide it as OWNER_ID env var"
    fi;

    if [[ -z ${PARTNER_ID} ]];
    then 
    error "Partner id is not set. Provide it as PARTNER_ID env var"
    fi;

    echo "adding owner to gpg store"
    gpg --armor --pinentry-mode loopback --passphrase-file ${PASSPHRASE_FILE} --import ${OWNER_KEY_FILE}

    echo "updating owner trust to ultimate"
    trust_fingerprint=$(gpg --fingerprint ${OWNER_ID}|grep -v "pub\|uid\|sub"|grep " "|sed 's/ //g')
    echo "${trust_fingerprint}:6:"|gpg --import-ownertrust

    echo "adding partner to gpg store"
    gpg --armor --pinentry-mode loopback --import ${PARTNER_PUBLIC_KEY_FILE}

    echo "updating partner trust"
    partner_trust_fingerprint=$(gpg --fingerprint ${PARTNER_ID}|grep -v "pub\|uid\|sub"|grep " "|sed 's/ //g')
    echo "${partner_trust_fingerprint}:6:"|gpg --import-ownertrust

}

_crypto() {
  local op=$1

  if [[ "${op}" != "encrypt" ]] && [[ "${op}" != "decrypt" ]]; then 
    error "unknown operation [$op]"
  fi;

  local input=$2
  local output=$3
  if [[ -z ${input} ]] || [[ -z ${output} ]]; then
    error "encrypt operation requires input and output file"
  fi;
  if [[ ! -f ${input} ]];
  then 
    error "input file ${input} does not exist"
  fi;

  if [[ -f ${output} ]];
  then 
    error "output file ${output} exists. refusing to overwrite."
  fi;
  _init_crypto
  
  echo "operation: ${op}"
  case $op in 
    encrypt)
      gpg --armor --pinentry-mode loopback -u "${OWNER_ID}" --passphrase-file ${PASSPHRASE_FILE} -r "${PARTNER_ID}" -o ${output} --encrypt ${input}
      ;;
    decrypt)
      gpg --armor --pinentry-mode loopback -u "${OWNER_ID}" --passphrase-file ${PASSPHRASE_FILE} -r "${PARTNER_ID}" -o ${output} --decrypt ${input}
      ;;
  esac;

}

_crypto $@
rm -rf ~/.gnupg
if [[ -f /tmp/work-dir/_tmp_file ]]; then 
  rm /tmp/work-dir/_tmp_file
fi;
export PASSPHRASE_FILE=user2/password2.txt
export OWNER_KEY_FILE=user2/user2.key
export PARTNER_PUBLIC_KEY_FILE=user2/user1.pub

export S3_SECRETS_FILE=user2/secrets/S3_DATA

#dynamic-config/daily.json
export EOD_DATE=2021-07-08
export FREQUENCY=daily
export CONFIG_ENDPOINT="https://raw.githubusercontent.com/skhatri/gpg-by-example/main/dynamic-config/decrypt-job.json"
./handler.sh "decrypt"


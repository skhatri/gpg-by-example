rm -rf ~/.gnupg

if [[ -f /tmp/work-dir/_encrypted_file ]]; then 
  rm /tmp/work-dir/_encrypted_file
fi;

export PASSPHRASE_FILE=user1/password1.txt
export OWNER_KEY_FILE=user1/user1.key
export PARTNER_PUBLIC_KEY_FILE=user1/user2.pub
export S3_SECRETS_FILE=user1/secrets/S3_DATA

#dynamic-config/daily.json
export EOD_DATE=2021-07-08
export FREQUENCY=monthly
export CONFIG_ENDPOINT="https://raw.githubusercontent.com/skhatri/gpg-by-example/main/dynamic-config/monthly.json"
export WEBHOOK_ENDPOINT="http://localhost:6100/echo"
export WEBHOOK_NOTIFICATION_TEMPLATE="{\"next_step\": \"do stuff\", \"path\":\"__UPLOAD_FILE__\"}"
./handler.sh "encrypt"


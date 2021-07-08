rm -rf ~/.gnupg

if [[ -f /tmp/work-dir/_encrypted_file ]]; then 
  rm /tmp/work-dir/_encrypted_file
fi;

export PASSPHRASE_FILE=user1/password1.txt
export OWNER_KEY_FILE=user1/user1.key
export OWNER_ID=user1@me.com
export PARTNER_ID=user2@me.com
export PARTNER_PUBLIC_KEY_FILE=user1/user2.pub

export DOWNLOAD_FILE=s3://gpg-by-example/test1/input.txt
export UPLOAD_FILE=s3://gpg-by-example/test1-encrypted/input.encrypted.txt
export S3_SECRETS_FILE=user1/secrets/S3_DATA
./handler.sh "encrypt"


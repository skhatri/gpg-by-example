rm -rf ~/.gnupg
if [[ -f /tmp/work-dir/_tmp_file ]]; then 
  rm /tmp/work-dir/_tmp_file
fi;
export PASSPHRASE_FILE=user2/password2.txt
export OWNER_KEY_FILE=user2/user2.key
export OWNER_ID=user2@me.com
export PARTNER_ID=user1@me.com
export PARTNER_PUBLIC_KEY_FILE=user2/user1.pub

export DOWNLOAD_FILE=s3://gpg-by-example/test1-encrypted/input.encrypted.txt
export UPLOAD_FILE=s3://gpg-by-example/test1/input3.txt
export S3_SECRETS_FILE=user2/secrets/S3_DATA
./handler.sh "decrypt"


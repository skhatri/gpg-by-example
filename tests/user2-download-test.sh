rm -rf ~/.gnupg
export PASSPHRASE_FILE=/home/app/password2.txt
export OWNER_KEY_FILE=/home/app/user2.key
export OWNER_ID=user2@me.com
export PARTNER_ID=user1@me.com
export PARTNER_PUBLIC_KEY_FILE=/home/app/user1.pub

export DOWNLOAD_FILE=s3://gpg-by-example/test1-encrypted/input.encrypted.txt
export UPLOAD_FILE=s3://gpg-by-example/test1/input2.txt
export S3_SECRETS_FILE=/home/app/secrets/S3_DATA
/opt/app/download-decrypt-upload.sh 


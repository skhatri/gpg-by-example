#!/usr/bin/env bash

if [[ -f sts-result.json ]]; then 
  rm sts-result.json
fi;

./create-s3-key.sh

docker run -v $(pwd)/tests:/tmp/tests -v $(pwd)/user1:/home/app  -v $(pwd)/pubkeys:/tmp/data -v $(pwd)/data:/data \
-e PASSPHRASE_FILE=/home/app/password1.txt \
-e OWNER_KEY_FILE=/home/app/user1.key \
-e OWNER_ID=user1@me.com \
-e PARTNER_ID=user2@me.com \
-e PARTNER_PUBLIC_KEY_FILE=/home/app/user2.pub \
-e DOWNLOAD_FILE=s3://gpg-by-example/test1/input.txt \
-e UPLOAD_FILE=s3://gpg-by-example/test1-encrypted/input.encrypted.txt \
-e S3_SECRETS_FILE=/home/app/secrets/S3_DATA \
-it gpg "encrypt"

docker run -v $(pwd)/tests:/tmp/tests -v $(pwd)/user2:/home/app  -v $(pwd)/pubkeys:/tmp/data -v $(pwd)/data:/data \
-e PASSPHRASE_FILE=/home/app/password2.txt \
-e OWNER_KEY_FILE=/home/app/user2.key \
-e OWNER_ID=user2@me.com \
-e PARTNER_ID=user1@me.com \
-e PARTNER_PUBLIC_KEY_FILE=/home/app/user1.pub \
-e DOWNLOAD_FILE=s3://gpg-by-example/test1-encrypted/input.encrypted.txt \
-e UPLOAD_FILE=s3://gpg-by-example/test1/input_decrypted.txt \
-e S3_SECRETS_FILE=/home/app/secrets/S3_DATA \
-it gpg "decrypt"


## Quickstart

### Tests

```
# encrypt test
./test-encrypt.sh

# decrypt test
./test-decrypt.sh

# download encrypt upload test
./test-download-encrypt-upload.sh

# download decrypt upload test
./test-download-decrypt-upload.sh

```

### Running inside container
```
./run.sh user1
    # encrypt locally
    - /tmp/tests/user1-test.sh
    # download, encrypt, upload to s3
    - /tmp/tests/user1-download-test.sh

./run.sh user2
    # decrypt locally
    - /tmp/tests/user2-test.sh
    # download, decrypt, upload to s3
    - /tmp/tests/user2-download-test.sh

```

### Test Entrypoint and Cmd
Performs download,encrypt,upload and download,decrypt,upload using user1 and user2
```
./test-entrypoint.sh
```

### Passing Configuration

|Variable| Description                                                                                                                           |
|---|---------------------------------------------------------------------------------------------------------------------------------------|
|ENABLE_ENCRYPTION| Enable/disable encryption                                                                                                             |
|ENABLE_DECRYPTION| Enable/disable decryption                                                                                                             |
|CONFIG_ENDPOINT| Endpoint to be used to download env var eg https://raw.githubusercontent.com/skhatri/gpg-by-example/main/dynamic-config/monthly.json  |
|WEBHOOK_ENDPOINT| Endpoint to call at the end of the task                                                                                               |
|WEBHOOK_ENDPOINT_TEMPLATE| Template to be used to create webhook payload. __UPLOAD_FILE__ and __DOWNLOAD_FILE__ will be substituted                              |
|WEBHOOK_ENDPOINT_3| Add another webhook                                                                                                                   |
|WEBHOOK_ENDPOINT_3_TEMPLATE| Payload for webhook endpoint 3                                                                                                        |
|EOD_DATE| End of Date if requiring dynamic calculation of upload/download file                                                                  |
|FREQUENCY| eg daily,monthly which is used along with EOD_DATE to work out the date value in file path                                            |
|IGNORE_MDC_ERROR| Set to "true" if you want to use flag "--ignore-mdc-error" to decrypt                                                                 |
|CRYPTOGRAPHY_SCRIPT| Can provide a custom script that will execute some encrypt/decrypt command. By default, it will use `crypto.sh` for gpg encrypt/decrypt |




## Gpg Setup Inside Container
### Set up user1
```
./run.sh user1
gpg --full-generate-key
```

### Setup user2
```
./run.sh user2
gpg --full-generate-key
```

### Export keys
```
./run.sh user1
gpg --export -a user1@me.com > /tmp/data/user1.pub

./run.sh user2
gpg --export -a user2@me.com > /tmp/data/user2.pub
```
### Import keys
```
./run.sh user1
gpg --import -a ~/user2.pub

./run.sh user2
gpg --import -a ~/user1.pub
gpg --recv-keys 0x62aee537 
```

### Encrypt and Sign
```
./run.sh user1
gpg -se --armor --always-trust --pinentry-mode loopback -u "user1@me.com" --passphrase "password1" -r "user2@me.com" -o /data/for_user2_encrypted.txt /data/input_file.txt
```
### Decrypt File
```
./run.sh user2
gpg -d --pinentry-mode loopback -u "user2@me.com" -passphrase "password2" -o /data/user2_plain.txt /data/for_user2_encrypted.txt
```

### Export Private Key
```
./run.sh user1
gpg --armor --pinentry-mode loopback --export-secret-keys -u "user1@me.com" --passphrase "password1" > /data/user1.key
gpg --import /data/user1.key
```

### Check Fingerprint
```
./run.sh user1
gpg --fingerprint user1@me.com
gpg --fingerprint user2@me.com
```

### Delete Key
```
./run.sh user1
gpg --delete-keys user2@me.com
```

### Import with Trust
```
./run.sh user1
gpg --import user2.pub
gpg --fingerprint user2@me.com
trust_fingerprint=$(gpg --fingerprint user2@me.com|grep -v "pub\|uid\|sub"|grep " "|sed 's/ //g')
echo "${trust_fingerprint}:6:"|gpg --import-ownertrust
```





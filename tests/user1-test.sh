rm -rf ~/.gnupg

if [[ -f /data/_encrypted_file ]];then 
  rm /data/_encrypted_file
fi;

export PASSPHRASE_FILE=/home/app/password1.txt
export OWNER_KEY_FILE=/home/app/user1.key
export OWNER_ID=user1@me.com
export PARTNER_ID=user2@me.com
export PARTNER_PUBLIC_KEY_FILE=/home/app/user2.pub
/opt/app/crypto.sh encrypt /data/input_file.txt /data/_encrypted_file


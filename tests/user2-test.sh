rm -rf ~/.gnupg

if [[ -f /data/input_file.txt.2  ]];then 
  rm /data/input_file.txt.2
fi;

export PASSPHRASE_FILE=/home/app/password2.txt
export OWNER_KEY_FILE=/home/app/user2.key
export OWNER_ID=user2@me.com
export PARTNER_ID=user1@me.com
export PARTNER_PUBLIC_KEY_FILE=/home/app/user1.pub
/opt/app/crypto.sh decrypt /data/_encrypted_file /data/input_file.txt.2 


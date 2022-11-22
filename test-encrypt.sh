rm -rf ~/.gnupg

if [[ -f /tmp/work-dir/_encrypted_file ]];then 
  rm /tmp/work-dir/_encrypted_file
fi;
if [[ ! -f /tmp/work-dir/_tmpfile ]];then
  mkdir -p /tmp/work-dir
  echo "hello world" > /tmp/work-dir/_tmpfile
fi;

export PASSPHRASE_FILE=user1/password1.txt
export OWNER_KEY_FILE=user1/user1.key
export OWNER_ID=user1@me.com
export PARTNER_ID=user2@me.com
export PARTNER_PUBLIC_KEY_FILE=user1/user2.pub
./crypto.sh encrypt /tmp/work-dir/_tmpfile /tmp/work-dir/_encrypted_file


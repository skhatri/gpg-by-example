rm -rf ~/.gnupg
if [[ -f /tmp/work-dir/_tmpfile2 ]]; then 
  rm /tmp/work-dir/_tmpfile2
fi;

export PASSPHRASE_FILE=user2/password2.txt
export OWNER_KEY_FILE=user2/user2.key
export OWNER_ID=user2@me.com
export PARTNER_ID=user1@me.com
export PARTNER_PUBLIC_KEY_FILE=user2/user1.pub
./crypto.sh decrypt /tmp/work-dir/_encrypted_file /tmp/work-dir/_tmpfile2



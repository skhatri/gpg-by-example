if [[ ! -f sts-result.json ]];
then
  aws sts get-session-token > sts-result.json
fi;

access_key=$(jq -r '.Credentials.AccessKeyId' sts-result.json)
secret_key=$(jq -r '.Credentials.SecretAccessKey' sts-result.json)
session_token=$(jq -r '.Credentials.SessionToken' sts-result.json)

echo '{"accessKeyId": "'${access_key}'", "secretAccessKey": "'${secret_key}'", "sessionToken": "'${session_token}'"}' > token.json

if [[ ! -d user1/secrets ]]; then 
  mkdir user1/secrets
fi;

if [[ ! -d user2/secrets ]]; then 
  mkdir user2/secrets
fi;

cp token.json user1/secrets/S3_DATA
cp token.json user2/secrets/S3_DATA

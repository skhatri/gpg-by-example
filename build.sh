artifact=gpg
owner=pflookyy
version=0.7.4
docker build --no-cache -t ${owner}/${artifact}:${version} .
docker push ${owner}/${artifact}:${version}



artifact=gpg
owner=skhatri
version=0.7.6
docker build --no-cache -t ${owner}/${artifact}:${version} .
docker push ${owner}/${artifact}:${version}



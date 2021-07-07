artifact=gpg
owner=skhatri
version=0.1
docker build --no-cache -t ${owner}/${artifact}:${version} .
docker push ${owner}/${artifact}:${version}



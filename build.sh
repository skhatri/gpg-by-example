artifact=gpg
owner=skhatri
version=0.2
docker build --no-cache -t ${owner}/${artifact}:${version} .
docker push ${owner}/${artifact}:${version}



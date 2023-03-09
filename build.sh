artifact=gpg
owner=skhatri
version=0.8.3
docker build --no-cache --platform linux/amd64 -t ${owner}/${artifact}:${version} .
docker push ${owner}/${artifact}:${version}



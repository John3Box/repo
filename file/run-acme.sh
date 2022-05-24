#!/bin/sh

_dir=$(dirname $0)

docker run --rm  -it  \
	-v file_acme:/acme.sh  \
	neilpang/acme.sh  --issue -d 3arm.ml \
	-d "www.3arm.ml" \
	-d "m.3arm.ml" \
	-d "rss.3arm.ml" \
	-d "vnc.3arm.ml" \
	-d "file.3arm.ml" \
	-d "k8s.3arm.ml" \
	-d "mail.3arm.ml" \
	--server https://acme-v02.api.letsencrypt.org/directory \
	-w /acme.sh  "$@"


docker run --rm  -it  \
	-v file_acme:/acme.sh  \
	neilpang/acme.sh  --issue -d arm.3host.cf \
	--server https://acme-v02.api.letsencrypt.org/directory \
	-w /acme.sh  "$@"

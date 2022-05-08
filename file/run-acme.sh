#!/bin/sh


docker run --rm  -it  \
	-v /opt/docker/file/acme/3arm.ml:/acme.sh/3arm.ml  \
	-v /opt/docker/file/acme/acme-challenge:/acme.sh/.well-known/acme-challenge \
	neilpang/acme.sh  --issue -d 3arm.ml \
	--issue -d file.3arm.ml \
	--issue -d m.3arm.ml \
	--issue -d vnc.3arm.ml \
	--issue -d www.3arm.ml \
	--server https://acme-v02.api.letsencrypt.org/directory \
	-w /acme.sh  "$@"

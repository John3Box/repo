#!/bin/sh

_dir=$(dirname $0)

docker run --rm  -it  \
	-v ${_dir}/acme/3arm.ml:/acme.sh/3arm.ml  \
	-v ${_dir}/acme/acme-challenge:/acme.sh/.well-known/acme-challenge \
	neilpang/acme.sh  --issue -d 3arm.ml \
	--issue -d file.3arm.ml \
	--issue -d m.3arm.ml \
	--issue -d vnc.3arm.ml \
	--issue -d www.3arm.ml \
	--issue -d rss.3arm.ml \
	--server https://acme-v02.api.letsencrypt.org/directory \
	-w /acme.sh  "$@"

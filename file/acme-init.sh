#!/bin/sh


docker run --rm  -it  \
	-v acme:/acme.sh  \
	-p 80:80 \
	neilpang/acme.sh \
	--issue -d "3arm.ml" \
	-d "www.3arm.ml" \
	-d "m.3arm.ml" \
	-d "rss.3arm.ml" \
	-d "vnc.3arm.ml" \
	-d "file.3arm.ml" \
	-d "k8s.3arm.ml" \
	--standalone --server https://acme-v02.api.letsencrypt.org/directory  "$@"

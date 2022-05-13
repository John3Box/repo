#!/bin/sh

docker run -d --name php-fpm \
	--restart always --security-opt=no-new-privileges \
	--cap-drop=mknod --cap-drop=sys_admin \
	-v /opt/docker/php-fpm/file.cdn.3host.cf/www:/var/www/file.cdn.3host.cf/www:rw \
	-v /opt/docker/php-fpm/etc/php-fpm.d/zz-docker.conf:/usr/local/etc/php-fpm.d/zz-docker.conf:ro \
	-v /opt/docker/php-fpm/php:/php \
	john3host/php-fpm-zip:arm64

#!/bin/sh

docker rm -f nginx
docker run -d --name nginx -p 0.0.0.0:80:80 -p 0.0.0.0:443:443 \
	--restart unless-stopped --security-opt=no-new-privileges \
	--cap-drop=mknod --cap-drop=sys_admin \
	-v /opt/docker/nginx/nginx:/etc/nginx:ro \
	-v /misc/3host.cf:/misc/3host.cf:ro \
	-v /misc/3arm.ml:/misc/3arm.ml:ro \
	-v /opt/docker/php-fpm/file.cdn.3host.cf/www:/var/www/file.cdn.3host.cf/www:ro \
	-v /opt/docker/nginx/3host.cf/www:/var/www/3host.cf/www:ro \
	--link php-fpm:php-fpm \
	nginx


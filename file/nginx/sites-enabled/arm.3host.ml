upstream 3host {
	server 172.18.0.1:6080;
}

map $http_upgrade $connection_upgrade {
	default upgrade;
	'' close;
}
 
server {
	listen		80;
	server_name	arm.3host.cf;

	root /var/www/html;
	include acme-challenge;
	location / {
		return 301 https://$host$request_uri;
	}
	access_log off;
	error_log /dev/null;
}

server {
	listen		443 ssl http2;
	server_name	arm.3host.cf;

	include 3host.cf-ssl;

	index	index.html;
	root /var/www/html;
	
	location / {
		proxy_pass http://novnc_6080/;

		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection $connection_upgrade;

		# VNC connection timeout
		proxy_read_timeout 61s;

		# Disable cache
		proxy_buffering off;

		# general proxy env
		include proxy_params;
	}
}


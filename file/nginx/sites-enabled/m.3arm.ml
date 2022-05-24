server {
	listen		80;
	server_name	m.3arm.ml;

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
	server_name	m.3arm.ml;

	include 3arm.ml-ssl;

	index	index.html;
	root /var/www/html;
	
	location / {
		proxy_pass http://172.18.0.1:3000/;

		proxy_http_version 1.1;

		# general proxy env
		include proxy_params;
	}
}


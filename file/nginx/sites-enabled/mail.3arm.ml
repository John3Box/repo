server {
	listen		80;
	server_name	mail.3arm.ml;

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
	server_name	mail.3arm.ml;

	include 3arm.ml-ssl;
	
	index	index.html;
	root /var/www/html;
	
	location / {
		proxy_pass http://10.9.144.25/;

		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection $connection_upgrade;

		# general proxy env
		include proxy_params;
	}
}


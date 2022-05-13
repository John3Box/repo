server {
	listen		80;
	server_name	rss.3arm.ml;

	root /var/www/html;
	location /.well-known/acme-challenge/ {
		alias /acme.sh/acme-challenge/;
	}

	location / {
		return 301 https://$host$request_uri;
	}
	access_log off;
	error_log /dev/null;
}

server {
	listen		443 ssl http2;
	server_name	rss.3arm.ml;

	include 3arm.ml-ssl;

	index	index.html;
	root /var/www/html;
	access_log off;
	error_log /dev/null;
	
	location / {
		proxy_pass http://172.18.0.1:8280/;
		proxy_http_version 1.1;
		include proxy_params;
	}
}


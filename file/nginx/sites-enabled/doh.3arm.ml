upstream dns-backend {
	server 10.9.144.1:8053;
}

server {
	listen		80;
	server_name	doh.3arm.ml;

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
	server_name	doh.3arm.ml;

	include 3arm.ml-ssl;
	
	index	index.html;
	root /var/www/html;
	#access_log off;
	#error_log /dev/null;
	
	location /getnsrecord {
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header Host $http_host;
		proxy_set_header X-NginX-Proxy true;
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_redirect off;
		proxy_set_header X-Forwarded-Proto $scheme;
		proxy_read_timeout 86400;
		proxy_pass http://dns-backend/getnsrecord ;
	}

	location /dns-query {
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header Host $http_host;
		proxy_set_header X-NginX-Proxy true;
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_redirect off;
		proxy_set_header X-Forwarded-Proto $scheme;
		proxy_read_timeout 86400;
		proxy_pass http://dns-backend/getnsrecord ;
	}
}

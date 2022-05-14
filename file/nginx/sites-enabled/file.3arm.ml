server {
	listen		80;
	server_name	file.3arm.ml;

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
	server_name	file.3arm.ml;

	include 3arm.ml-ssl;
	
	#access_log off;
	#error_log /dev/null;
	
	root /var/www/html/file.3arm.ml;
	index   index.php;
	disable_symlinks off;

	client_max_body_size 0;
	fastcgi_request_buffering off;

	# only allow php exec index.php
	location = /index.php {
		fastcgi_split_path_info ^(.+?\.php)(/.*)$;
		if (!-f $document_root$fastcgi_script_name) {
			return 404;
		}
		include fastcgi.conf;
		#fastcgi_pass unix:/php/www.socket;
		fastcgi_pass php-fpm:9000;
		fastcgi_index index.php;
	}

	location /filedata/ {
		autoindex on;
		index   index.html;
	}
}


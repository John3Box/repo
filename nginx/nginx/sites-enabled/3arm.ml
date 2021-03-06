upstream novnc_6080 {
	server 172.18.0.1:6080;
}

map $http_upgrade $connection_upgrade {
	default upgrade;
	'' close;
}
 
server {
	listen		80;
	server_name	3arm.ml m.3arm.ml file.3arm.ml vnc.3arm.ml www.3arm.ml;

	return 301 https://$host$request_uri;
	access_log off;
	error_log /dev/null;
}

server {
	listen		443 ssl http2;
	server_name	m.3arm.ml;
	server_name	3arm.ml www.3arm.ml;

	ssl_certificate		/misc/3arm.ml/fullchain.cer;
	ssl_certificate_key	/misc/3arm.ml/3arm.ml.key;

	# ocsp
	ssl_stapling on;
	ssl_stapling_verify on;
	ssl_trusted_certificate /misc/3arm.ml/ca.cer;
	
	index	index.html;
	root /var/www/3arm.ml/www;
	access_log off;
	error_log /dev/null;
	
	location / {
		proxy_pass http://172.18.0.1:3000/;

		proxy_http_version 1.1;

		# general proxy env
		include proxy_params;
	}
}

server {
	listen		443 ssl http2;
	server_name	vnc.3arm.ml;

	ssl_certificate		/misc/3arm.ml/fullchain.cer;
	ssl_certificate_key	/misc/3arm.ml/3arm.ml.key;

	# ocsp
	ssl_stapling on;
	ssl_stapling_verify on;
	ssl_trusted_certificate /misc/3arm.ml/ca.cer;
	
	index	index.html;
	root /var/www/3arm.ml/www;
	access_log off;
	error_log /dev/null;
	
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

server {
	listen		443 ssl http2;
	server_name	file.3arm.ml;

	ssl_certificate		/misc/3arm.ml/fullchain.cer;
	ssl_certificate_key	/misc/3arm.ml/3arm.ml.key;

	# ocsp
	ssl_stapling on;
	ssl_stapling_verify on;
	ssl_trusted_certificate /misc/3arm.ml/ca.cer;
	
	#access_log off;
	#error_log /dev/null;
	
	root /var/www/file.cdn.3host.cf/www;
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

	location /file/ {
		autoindex on;
        	index   index.html;
	}
}


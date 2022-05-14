#upstream novnc_6080 {
#	server 172.18.0.1:6080;
#}
#
map $http_upgrade $connection_upgrade {
	default upgrade;
	'' close;
}
 
server {
	listen		80;
	server_name	3arm.ml m.3arm.ml k8s.3arm.ml vnc.3arm.ml;

	return 301 https://$host$request_uri;
	access_log off;
	error_log /dev/null;
}

server {
	listen		443 ssl http2;
	server_name	k8s.3arm.ml;

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
		proxy_pass http://172.18.0.1:2080;

		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection $connection_upgrade;

		# general proxy env
		include proxy_params;
	}
}

server {
	listen		443 ssl http2;
	server_name	3arm.ml m.3arm.ml;

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
		proxy_pass http://172.18.0.1:3000;

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


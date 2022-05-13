docker exec -it php-fpm apt update
docker exec -it php-fpm apt upgrade -y
docker exec -it php-fpm apt install libzip-dev -y 
docker exec -it php-fpm apt clean
docker exec -it php-fpm docker-php-ext-install zip
docker restart php-fpm

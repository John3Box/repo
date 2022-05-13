FROM php:8.1-fpm

USER 0
RUN apt-get update; \
    apt-get -y upgrade; \
    apt-get install -y libzip-dev; \
    docker-php-ext-install zip; \
    docker-php-ext-enable zip; \
    # Success
    true


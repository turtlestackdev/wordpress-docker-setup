# This is just a simple wrapper around the wordpress image.
# All it does is setup XDEBUG in the image if the environment var WITH_XDEBUG = true.
# Defaults to false.
FROM wordpress:php8.2-fpm

ARG WITH_XDEBUG=false
ARG HOST_IP_ADDRESS="127.0.0.1"
ARG HOST_IDE_KEY="PHPSTORM"
ARG XDEBUG_PORT=9003
RUN if [ $WITH_XDEBUG = "true" ] ; then \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS; \
    pecl install xdebug; \
    docker-php-ext-enable xdebug; \
    apk del -f .build-deps; \
    mkdir /var/log/xdebug; \
    touch /var/log/xdebug/xdebug.log; \
    echo "zend_extension=xdebug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.client_port=$XDEBUG_PORT" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.client_host=$HOST_IP_ADDRESS" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.discover_client_host=true" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.idekey=$HOST_IDE_KEY" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.log=/dev/stdout" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
fi ;
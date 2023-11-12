FROM php:8.1-fpm-alpine

ARG UID
ARG GID

#ENV UID=${UID}
#ENV GID=${GID}

# Set environment variables
ARG TZ=Europe/Amsterdam
ENV TZ ${TZ}

# The www-data is already used in the base package!
# 82 is the standard uid/gid for "www-data" in Alpine
# https://git.alpinelinux.org/aports/tree/main/apache2/apache2.pre-install?h=3.14-stable
# https://git.alpinelinux.org/aports/tree/main/lighttpd/lighttpd.pre-install?h=3.14-stable
# https://git.alpinelinux.org/aports/tree/main/nginx/nginx.pre-install?h=3.14-stable

#RUN addgroup -g 1000 --system dofroscra; \
#    adduser -G dofroscra --system -D -s /bin/sh -u 1000 dofroscra

RUN echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories

# Install dependencies
RUN set -eux; \
    apk add --update --no-cache --virtual .build-deps \
    libjpeg-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
#   Already added!
#   libxml2-dev \
    libzip-dev \
    autoconf \
    git \
#   Already added!
#   linux-headers \
    mariadb-client \
    nano \
# for usermod (that's not in alpine originally)
    #shadow \
    unzip \
    wget \
    zip \
    $PHPIZE_DEPS;

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN install-php-extensions \
    bcmath \
    exif \
    gd \
    imagick \
    imap \
    intl \
    mysqli \
    pdo_mysql \
    redis \
    ssh2 \
    xdebug \
    xmlrpc \
    xsl \
    zip; \
    \
# update pecl channel definitions https://github.com/docker-library/php/issues/443
# Already done!
#   pecl update-channels; \
    pecl install \
        mcrypt \
        redis \
        xdebug \
    ; \
    docker-php-ext-enable mcrypt; \
    docker-php-ext-enable redis; \
    docker-php-ext-enable xdebug; \
    rm -rf /tmp/pear ~/.pearrc; \
    \
    runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
    apk add --update --no-cache --virtual .run-deps $runDeps; \
    apk del .build-deps; \
    \
    php --version

# Xdebug enabled by default
RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.client_port=9005" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.idekey='PHPStorm'" >> /usr/local/etc/php/conf.d/xdebug.ini \
    #&& echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

# Copy the php-fpm config
COPY ./dofroscra.fpm.conf /usr/local/etc/php-fpm.d/zzz-dofroscra.fpm.conf
COPY ./dofroscra.php.ini /usr/local/etc/php/conf.d/dofroscra.php.ini

# clear cache
RUN rm -rf /var/cache/apk/*

USER root

RUN mkdir -p /var/www/projects


# change user and groups ids
#RUN usermod --uid=1000 www-data && \
#    groupmod --gid=1000 www-data && \
# fix permissions
#    chown -R www-data:www-data /var/www/projects/

# Set the proper permissions
#RUN usermod -u 1000 www-data

#RUN addgroup -g 1000 --system dofroscra; \
#    adduser -G dofroscra --system -D -s /bin/bash -u 1337 dofroscra

#RUN groupadd --force -g 1000 dofroscra
#RUN useradd -ms /bin/bash --no-user-group -g 1000 -u 1337 dofroscra
#RUN addgroup -g 1000 --system dofroscra; \
#    adduser -G dofroscra --system -D -s /bin/sh -u 1000 dofroscra

# Clean up
RUN rm -rf /usr/share/php /usr/share/php8 /usr/src/* /usr/local/bin/phpdbg \
        /usr/local/bin/install-php-extensions /var/lib/apt/lists/* /tmp/* /var/tmp/*

    # Miscellany
RUN adduser --disabled-password --gecos "" -u 1337 -s /bin/sh -G www-data dofroscra \
    #&& ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    #&& chmod +x /usr/local/bin/start-container \
    && echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories \
    && apk --no-cache add shadow \
    && usermod -u 1000 www-data

RUN chown -R www-data:www-data /var/www/projects

USER www-data

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]

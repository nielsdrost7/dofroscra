ARG ALPINE_VERSION
ARG COMPOSER_VERSION
FROM composer:2.2.5 as composer
FROM alpine:3.15 as base

# make build args available as ENV variables to downstream images
# so that we don't have to pass the same build args again
ARG APP_USER_ID
ARG APP_GROUP_ID
ARG APP_USER_NAME
ARG APP_GROUP_NAME
ARG APP_CODE_PATH
ARG TARGET_PHP_VERSION
ARG ALPINE_VERSION
ARG ENV
ENV APP_USER_ID=${APP_USER_ID}
ENV APP_GROUP_ID=${APP_GROUP_ID}
ENV APP_USER_NAME=${APP_USER_NAME}
ENV APP_GROUP_NAME=${APP_GROUP_NAME}
ENV APP_CODE_PATH=${APP_CODE_PATH}
ENV TARGET_PHP_VERSION=8.1
ENV ALPINE_VERSION=3.15
ENV ENV=local

RUN addgroup -g $APP_GROUP_ID $APP_GROUP_NAME && \
    adduser -D -u $APP_USER_ID -s /bin/bash $APP_USER_NAME -G $APP_GROUP_NAME && \
    mkdir -p $APP_CODE_PATH && \
    chown $APP_USER_NAME: $APP_CODE_PATH

RUN apk add --update --no-cache \
        bash \
        make \
        strace \
        sudo \
        vim

# install PHP
# Note: we need to use a custom apk repository because the official ones will
#       likely not include the latest PHP version.
# @see https://github.com/codecasts/php-alpine
ADD https://php.hernandev.com/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

RUN apk --update-cache add ca-certificates && \
    echo "https://php.hernandev.com/v3.15/php-8.1" >> /etc/apk/repositories && \
    apk add --update --no-cache  \
        php8~=8.1 \
        php-dom~=8.1 \
        php-mbstring~=8.1 \
        php-pdo_mysql~=8.1 \
        php-pdo~=8.1 \
        php-phar~=8.1 \
        php-redis~=8.1 \
        php-xml~=8.1 \
# make "php" as command available by creating a symlink
# https://github.com/codecasts/php-alpine/issues/20#issuecomment-350477886
    && ln -s /usr/bin/php8 /usr/bin/php

# make bash default shell
RUN sed -e 's;/bin/ash$;/bin/bash;g' -i /etc/passwd

COPY ./.docker/php-fpm/conf.d/zz-app.ini /etc/php8/conf.d/
COPY ./.docker/php-fpm/conf.d/zz-app-local.ini /etc/php8/conf.d/

COPY ./.bashrc /home/${APP_USER_NAME}/.bashrc
COPY ./.bashrc /root/.bashrc

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

WORKDIR $APP_CODE_PATH

# add app user to sudoers
# see https://ostechnix.com/add-delete-and-grant-sudo-privileges-to-users-in-alpine-linux/ for adding sudo
# see https://askubuntu.com/a/340669 for not requiring a sudo pw
RUN echo "root ALL=(ALL) NOPASSWD: ALL " | tee -a "/etc/sudoers.d/users" && \
    echo "${APP_USER_NAME} ALL=(ALL) NOPASSWD: ALL " | tee -a "/etc/sudoers.d/users"

RUN apk add --no-cache --update \
        mysql-client \
        redis \
        php-xdebug~=8.1 \
    # ensure that xdebug is not enabled by default
    && rm -f /etc/php8/conf.d/00_xdebug.ini

RUN apk add --no-cache --update \
        supervisor \
    && rm -rf /etc/supervisord.conf

COPY ./.docker/php-worker/supervisor/ /etc/supervisor/

ARG PHP_WORKER_PROCESS_NUMBER
ARG PHP_WORKER_COMMAND="php $APP_CODE_PATH/worker.php"
ARG PHP_WORKER_COMMAND_ARGS
RUN    sed -i "s/numprocs=__PHP_WORKER_PROCESSES_NUMBER/numprocs=$PHP_WORKER_PROCESS_NUMBER/" /etc/supervisor/supervisord.conf \
    && sed -i "s#command=__PHP_WORKER_COMMAND#command=$PHP_WORKER_COMMAND $PHP_WORKER_COMMAND_ARGS#" /etc/supervisor/supervisord.conf \
    && sed -i "s/__APP_USER_NAME/$APP_USER_NAME/" /etc/supervisor/supervisord.conf \
    && mkdir /var/run/application/ \
    && chown $APP_USER_NAME:$APP_GROUP_NAME /var/run/application/

EXPOSE 9001

USER $APP_USER_NAME

CMD ["supervisord"]

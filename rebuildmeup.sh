#!/bin/bash

docker-compose --env-file .env build --no-cache beanstalkd beanstalkd-console mariadb nginx php-fpm phpmyadmin redis redis-webui workspace

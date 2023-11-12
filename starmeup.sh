#!/bin/bash
docker-compose --env-file .env.docker up nginx db php-fpm phpmyadmin workspace redis

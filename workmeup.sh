#!/bin/bash
docker exec --env-file .env.docker -it --user=alpinehero $(docker ps -aqf "name=workspace") bash

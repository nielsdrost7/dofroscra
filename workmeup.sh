#!/bin/bash
docker exec -it --user=dofroscra $(docker ps -aqf "name=workspace") bash

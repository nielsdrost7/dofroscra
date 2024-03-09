#!/bin/bash

#get all containers
containers=`docker ps -a --format '{{.Names}}'`

hostFileBegin="## DOCKERHERO HOSTS BLOCK START ##\n"
hostFileEnd="## DOCKERHERO HOSTS BLOCK END ##\n"
hostFile=$hostFileBegin

#find the ip belonging to container
for containerName in ${containers[@]}
do
    containerIP=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $containerName`
    hostFile+="$containerIP $containerName\n"
done

hostFile+=$hostFileEnd

echo -e $hostFile

exit

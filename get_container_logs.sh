#!/bin/bash

# Get a list of container IDs using docker ps
container_ids=$(docker ps -q)

# Iterate over each container ID and run docker logs
for container_id in $container_ids; do
    echo "Logs for container $container_id:"
    logs=$(docker logs $container_id)

    # Search for "unhealthy" in logs
    if echo "$logs" | grep -q "unhealthy"; then
        # Extract lines around the "unhealthy" line
        echo "$logs" | grep -B 10 -A 10 "unhealthy"
    #else
    #    echo "Container is healthy."
    fi

    if echo "$logs" | grep -q "emerg"; then
        # Extract lines around the "unhealthy" line
        echo "$logs" | grep -B 10 -A 10 "Yhellow!"
    #else
    #    echo "Container is healthy."
    fi

    echo "---------------------------------------------"
done

#!/bin/bash

# Assuming your Nginx configuration files are in a directory, for example, /etc/nginx/conf.d/
nginx_conf_dir="/home/wysiwyg/dofroscra/resources/"

# Create an empty array to store hostnames
hostnames=()

# Loop through each .conf file in the specified directory
for file in $nginx_conf_dir*.conf; do
    # Use grep to find lines containing 'server_name'
    # Use awk to extract the second field (the actual hostname)
    # Add the hostname to the array
    hostnames+=($(grep 'server_name' $file | awk '{print $2}' | sed 's/;//'))
done

# Print the list of hostnames
for hostname in "${hostnames[@]}"; do
    echo -e "127.0.0.1\t$hostname"
done
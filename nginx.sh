#!/bin/bash

sleep 30

sudo yum update -y

# install nginx
sudo amazon-linux-extras install nginx1 -y

# Update nginx file locations
sudo mv /tmp/upstream.conf /etc/nginx/upstream.conf
sudo mv /tmp/nginx.conf /etc/nginx/nginx.conf

# Update the nginx file owner
sudo chown root /etc/nginx/upstream.conf
sudo chgrp root /etc/nginx/upstream.conf
sudo chown root /etc/nginx/nginx.conf
sudo chgrp root /etc/nginx/nginx.conf

# Start Nginx
sudo systemctl enable nginx
sudo systemctl start nginx
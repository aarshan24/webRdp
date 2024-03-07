#!/bin/sh

# Start xrdp
xrdp -n

# Get IP address
ip=$(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -f1 -d'/')

# Print information
echo "IP: $ip"
echo "Port: 3389"
echo "Username: root"
echo "Password: root"

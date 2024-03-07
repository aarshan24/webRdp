# Use the Ubuntu base image with LXDE and VNC
FROM dorowu/ubuntu-desktop-lxde-vnc

# Expose port 80
EXPOSE 80

# Set the default network mode to bridge and specify the IP address
CMD ["--network=bridge", "--ip=198.251.79.65"]

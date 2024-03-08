# Use the Ubuntu base image with LXDE and VNC
FROM dorowu/ubuntu-desktop-lxde-vnc

# Expose port 80
EXPOSE 80

# Start the RDP server as the main process
CMD ["xrdp", "-n", "-d"]

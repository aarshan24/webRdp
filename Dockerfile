# Use the Ubuntu base image with LXDE and VNC
FROM dorowu/ubuntu-desktop-lxde-vnc

# Expose port 80
EXPOSE 80

# Install dependencies
RUN apt-get update && apt-get install -y \
    iproute2 \
    bridge-utils \
    net-tools

# Create a bridge network and assign an IP address
RUN ip link add br0 type bridge && \
    ip addr add 172.30.1.1/20 dev br0 && \
    ip link set br0 up

# Configure Docker to use the bridge network
CMD ["dockerd", "-b", "br0"]

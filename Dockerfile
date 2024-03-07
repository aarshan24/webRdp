FROM debian

# Install necessary packages
RUN dpkg --add-architecture i386 \
    && apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y \
        wine \
        qemu-kvm \
        xz-utils \
        curl \
        firefox-esr \
        gnome-system-monitor \
        mate-system-monitor \
        git \
        xfce4 \
        xfce4-terminal \
        tightvncserver \
        wget \
        xrdp \
        dbus-x11 \
        mate-desktop-environment-core \
        net-tools

# Install noVNC
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz \
    && tar -xvf v1.2.0.tar.gz

# Set up xrdp
RUN echo "mate-session" > /etc/skel/.xsession \
    && sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config \
    && echo "xfce4-session" > /etc/skel/.xsession

# Expose RDP port
EXPOSE 3389

# Start xrdp with error handling and debug information
CMD ["sh", "-c", "set -e; \
                  xrdp -n; \
                  ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -f1 -d'/' || echo 'Error retrieving IP address'; \
                  echo 'Username: root'; \
                  echo 'Password: root'"]

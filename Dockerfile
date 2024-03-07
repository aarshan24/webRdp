FROM debian

# Install pv and iproute2
RUN apt-get update && apt-get install -y pv iproute2

# Install necessary packages including Python
RUN set -eux; \
    dpkg --add-architecture i386; \
    apt update; \
    DEBIAN_FRONTEND=noninteractive apt install -y \
        python3 \
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
        net-tools; \
    apt clean; \
    rm -rf /var/lib/apt/lists/*

# Install numpy
RUN set -eux; \
    apt update; \
    DEBIAN_FRONTEND=noninteractive apt install -y python3-numpy; \
    apt clean; \
    rm -rf /var/lib/apt/lists/*

# Set up xrdp
RUN set -eux; \
    echo "mate-session" > /etc/skel/.xsession; \
    sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config; \
    echo "xfce4-session" > /etc/skel/.xsession

# Expose RDP port
EXPOSE 3389

# Start xrdp with error handling and debug information
CMD ["sh", "-c", "set -eux; \
                  if ! xrdp -n; then \
                      echo 'Failed to start xrdp'; \
                      exit 1; \
                  fi; \
                  ip=$(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -f1 -d'/'); \
                  port=3389; \
                  echo 'IP: ' $ip ':' $port; \
                  echo 'Username: root'; \
                  echo 'Password: root'"]

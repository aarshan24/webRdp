FROM debian

# Install pv and iproute2
RUN apt-get update && apt-get install -y pv iproute2

# Install necessary packages including Python3, pip3, and Flask
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
        python3 \
        python3-pip \
        python3-numpy \
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
        net-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up xrdp
RUN echo "mate-session" > /etc/skel/.xsession && \
    sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config && \
    echo "xfce4-session" > /etc/skel/.xsession

# Install Flask
RUN pip3 install flask

# Expose RDP and HTTP ports
EXPOSE 3389 80

# Copy Python script and HTML file to container
COPY get_info.py /
COPY index.html /

# Start xrdp and run Python script to print IP address, username, and password
CMD ["sh", "-c", "set -eux; \
                  xrdp -n; \
                  python3 /get_info.py & \
                  flask run --host=0.0.0.0 --port=80"]

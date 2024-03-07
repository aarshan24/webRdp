# Use the Debian base image
FROM debian

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    curl \
    dbus-x11 \
    xrdp

# Download and install Chrome Remote Desktop
RUN wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb && \
    dpkg -i chrome-remote-desktop_current_amd64.deb && \
    apt-get install -f -y && \
    rm chrome-remote-desktop_current_amd64.deb

# Install pv and iproute2
RUN apt-get install -y pv iproute2

# Install necessary packages
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
        python3 \
        python3-pip \
        python3-numpy \
        wine \
        qemu-kvm \
        xz-utils \
        firefox-esr \
        gnome-system-monitor \
        mate-system-monitor \
        git \
        xfce4 \
        xfce4-terminal \
        tightvncserver \
        mate-desktop-environment-core \
        net-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up xrdp
RUN echo "mate-session" > /etc/skel/.xsession && \
    sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config && \
    echo "xfce4-session" > /etc/skel/.xsession

# Set environment variables
ENV DISPLAY=
ENV CRD_CODE="4/0AeaYSHDTj2cYdvkGNd6eyZSXNFSA-Xnc2IX_DOkG0N7JPCjIVNqwLFp6Fk2K_Pjoxjsfrw"
ENV CRD_REDIRECT_URL="https://remotedesktop.google.com/_/oauthredirect"

# Start Chrome Remote Desktop
CMD ["/opt/google/chrome-remote-desktop/start-host", "--code=$CRD_CODE", "--redirect-url=$CRD_REDIRECT_URL"]

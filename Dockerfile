FROM debian

# Install necessary packages including Chrome Remote Desktop
RUN apt-get update && apt-get install -y \
        curl \
        dbus-x11 \
        gnupg \
        xdg-utils \
        wget \
        --no-install-recommends \
    && curl -sS -o /tmp/chrome_remote_desktop.deb https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb \
    && dpkg -i /tmp/chrome_remote_desktop.deb \
    && apt-get install -f -y \
    && rm /tmp/chrome_remote_desktop.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up Chrome Remote Desktop
RUN mkdir -p /usr/local/share/desktop-session \
    && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update && apt-get install -y \
        google-chrome-stable \
        --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && /opt/google/chrome-remote-desktop/setup --quiet --headless --pin=1234 \
    && echo "exec /etc/X11/Xsession /usr/local/share/desktop-session/startup" > /etc/chrome-remote-desktop-session \
    && chmod +x /etc/chrome-remote-desktop-session

# Set up xrdp
RUN apt-get update && apt-get install -y \
        xrdp \
        --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Expose xrdp port
EXPOSE 3389

# Start xrdp and Chrome Remote Desktop
CMD ["sh", "-c", "set -eux; \
                  xrdp -n; \
                  sleep 10; \
                  /usr/sbin/sshd -D"]

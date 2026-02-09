# Start from official Fedora Silverblue desktop base
FROM registry.fedoraproject.org/fedora-silverblue:43

# Set timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime

# Set locale
RUN echo 'LANG=da_DK.UTF-8' > /etc/locale.conf
RUN echo 'LC_TIME=da_DK.UTF-8' >> /etc/locale.conf

# Create a clean home template
RUN mkdir -p /usr/share/guest-template
RUN echo 'Welcome to the guest session!' > /usr/share/guest-template/welcome.txt
RUN mkdir -p /usr/share/guest-template/Desktop
RUN echo 'This is your desktop.' > /usr/share/guest-template/Desktop/readme.txt

# Create login script to set unique home directory
RUN mkdir -p /etc/profile.d
RUN echo '#!/bin/bash' > /etc/profile.d/dynamic-guest-home.sh
RUN echo 'if [ "$USER" = "guestuser" ]; then' >> /etc/profile.d/dynamic-guest-home.sh
RUN echo '    # Create unique home directory' >> /etc/profile.d/dynamic-guest-home.sh
RUN echo '    TIMESTAMP=$(date +%s)' >> /etc/profile.d/dynamic-guest-home.sh
RUN echo '    GUEST_HOME="/tmp/guest-home-$TIMESTAMP"' >> /etc/profile.d/dynamic-guest-home.sh
RUN echo '    mkdir -p "$GUEST_HOME"' >> /etc/profile.d/dynamic-guest-home.sh
RUN echo '    # Copy clean template' >> /etc/profile.d/dynamic-guest-home.sh
RUN echo '    cp -a /usr/share/guest-template/. "$GUEST_HOME/"' >> /etc/profile.d/dynamic-guest-home.sh
RUN echo '    # Set HOME environment variable' >> /etc/profile.d/dynamic-guest-home.sh
RUN echo '    export HOME="$GUEST_HOME"' >> /etc/profile.d/dynamic-guest-home.sh
RUN echo '    # Set XDG directories' >> /etc/profile.d/dynamic-guest-home.sh
RUN echo '    export XDG_DESKTOP_DIR="$HOME/Desktop"' >> /etc/profile.d/dynamic-guest-home.sh
RUN echo '    export XDG_DOWNLOAD_DIR="$HOME/Downloads"' >> /etc/profile.d/dynamic-guest-home.sh
RUN echo '    export XDG_DOCUMENTS_DIR="$HOME/Documents"' >> /etc/profile.d/dynamic-guest-home.sh
RUN echo 'fi' >> /etc/profile.d/dynamic-guest-home.sh
RUN chmod +x /etc/profile.d/dynamic-guest-home.sh

# Set guestuser's wallpaper via dconf
RUN mkdir -p /etc/dconf/db/local.d
RUN echo '[org/gnome/desktop/background]' > /etc/dconf/db/local.d/00-wallpaper
RUN echo "picture-uri='file:///usr/share/backgrounds/custom/guest-background.svg'" >> /etc/dconf/db/local.d/00-wallpaper
RUN echo "picture-options='zoom'" >> /etc/dconf/db/local.d/00-wallpaper

# Compile dconf database
RUN dconf update

# Copy custom SVG background
COPY guest-background.svg /usr/share/backgrounds/custom/guest-background.svg

# Configure GDM to auto-login guestuser
RUN mkdir -p /etc/gdm
RUN echo '[daemon]' > /etc/gdm/custom.conf
RUN echo 'AutomaticLoginEnable=True' >> /etc/gdm/custom.conf
RUN echo 'AutomaticLogin=guestuser' >> /etc/gdm/custom.conf

# Create systemd service to create guestuser on first boot
RUN mkdir -p /etc/systemd/system/create-guestuser.service.d
RUN echo '[Service]' > /etc/systemd/system/create-guestuser.service.d/override.conf
RUN echo 'ExecStartPre=/bin/mkdir -p /var/lib/guestuser' >> /etc/systemd/system/create-guestuser.service.d/override.conf
RUN echo 'ExecStart=/usr/sbin/useradd -m -s /bin/bash -c "Guest User" guestuser' >> /etc/systemd/system/create-guestuser.service.d/override.conf
RUN echo 'ExecStartPost=/usr/bin/echo "guestuser:" | /usr/sbin/chpasswd' >> /etc/systemd/system/create-guestuser.service.d/override.conf
RUN echo 'ExecStartPost=/bin/systemctl disable create-guestuser.service' >> /etc/systemd/system/create-guestuser.service.d/override.conf

RUN echo '[Unit]' > /etc/systemd/system/create-guestuser.service
RUN echo 'Description=Create guestuser on first boot' >> /etc/systemd/system/create-guestuser.service
RUN echo 'After=multi-user.target' >> /etc/systemd/system/create-guestuser.service
RUN echo 'Wants=multi-user.target' >> /etc/systemd/system/create-guestuser.service
RUN echo '' >> /etc/systemd/system/create-guestuser.service
RUN echo '[Service]' >> /etc/systemd/system/create-guestuser.service
RUN echo 'Type=oneshot' >> /etc/systemd/system/create-guestuser.service
RUN echo 'RemainAfterExit=yes' >> /etc/systemd/system/create-guestuser.service
RUN echo 'ExecStart=/usr/sbin/useradd -m -s /bin/bash -c "Guest User" guestuser' >> /etc/systemd/system/create-guestuser.service
RUN echo 'ExecStartPost=/usr/bin/echo "guestuser:" | /usr/sbin/chpasswd' >> /etc/systemd/system/create-guestuser.service
RUN echo 'ExecStartPost=/bin/systemctl disable create-guestuser.service' >> /etc/systemd/system/create-guestuser.service
RUN echo '' >> /etc/systemd/system/create-guestuser.service
RUN echo '[Install]' >> /etc/systemd/system/create-guestuser.service
RUN echo 'WantedBy=multi-user.target' >> /etc/systemd/system/create-guestuser.service

# Enable the service
RUN systemctl enable create-guestuser.service

# Final labels
LABEL maintainer="Agnete Moos <agms@sonderborg.dk>"
LABEL description="Custom Fedora Silverblue 43 desktop with dynamic guest home directory per login and auto-created guestuser"

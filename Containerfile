# Start from official Fedora Silverblue desktop base
FROM registry.fedoraproject.org/fedora-silverblue:43

# Set timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime

# Set locale
RUN echo 'LANG=da_DK.UTF-8' > /etc/locale.conf
RUN echo 'LC_TIME=da_DK.UTF-8' >> /etc/locale.conf

# Enable guest session in GDM
RUN mkdir -p /etc/gdm
RUN echo '[daemon]' > /etc/gdm/custom.conf
RUN echo 'AutomaticLoginEnable=True' >> /etc/gdm/custom.conf
RUN echo 'AutomaticLogin=guest' >> /etc/gdm/custom.conf
RUN echo 'AllowGuest=true' >> /etc/gdm/custom.conf

# Create guest user (required for auto-login to work)
RUN useradd -m -s /bin/bash -c "Guest User" guest

# Set guest session wallpaper via dconf
RUN mkdir -p /etc/dconf/db/local.d
RUN echo '[org/gnome/desktop/background]' > /etc/dconf/db/local.d/00-wallpaper
RUN echo "picture-uri='file:///usr/share/backgrounds/custom/guest-background.svg'" >> /etc/dconf/db/local.d/00-wallpaper
RUN echo "picture-options='zoom'" >> /etc/dconf/db/local.d/00-wallpaper

# Compile dconf database
RUN dconf update

# Copy custom SVG background
COPY guest-background.svg /usr/share/backgrounds/custom/guest-background.svg

# Final labels
LABEL maintainer="Agnete Moos <agms@sonderborg.dk>"
LABEL description="Custom Fedora Silverblue 43 desktop with auto-login guest session and custom wallpaper"

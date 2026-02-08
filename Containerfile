# Start from official Fedora Silverblue desktop base
FROM registry.fedoraproject.org/fedora-silverblue:43

# Set timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime

# Set locale
RUN echo 'LANG=da_DK.UTF-8' > /etc/locale.conf
RUN echo 'LC_TIME=da_DK.UTF-8' >> /etc/locale.conf

# Copy your custom SVG background into the image
COPY my-background.svg /usr/share/backgrounds/custom/my-background.svg

# Create a GNOME wallpaper definition
RUN mkdir -p /usr/share/backgrounds/custom
RUN echo '<wallpaper>' > /usr/share/backgrounds/custom/custom-wallpaper.xml
RUN echo '  <name>Custom SVG Background</name>' >> /usr/share/backgrounds/custom/custom-wallpaper.xml
RUN echo '  <filename>/usr/share/backgrounds/custom/my-background.svg</filename>' >> /usr/share/backgrounds/custom/custom-wallpaper.xml
RUN echo '  <options>zoom</options>' >> /usr/share/backgrounds/custom/custom-wallpaper.xml
RUN echo '  <pcolor>#000000</pcolor>' >> /usr/share/backgrounds/custom/custom-wallpaper.xml
RUN echo '  <scolor>#000000</scolor>' >> /usr/share/backgrounds/custom/custom-wallpaper.xml
RUN echo '</wallpaper>' >> /usr/share/backgrounds/custom/custom-wallpaper.xml

# Set GNOME to use this wallpaper
RUN gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/custom/my-background.svg'
RUN gsettings set org.gnome.desktop.background picture-options 'zoom'

# Final labels
LABEL maintainer="Agnete Moos <agms@sonderborg.dk>"
LABEL description="Custom Fedora Silverblue 43 desktop with custom SVG GNOME wallpaper"

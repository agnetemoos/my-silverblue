# Fedora Silverblue 43 Kickstart — Fully Automated Install
# Configured: Danish language, keyboard, Europe/Copenhagen timezone
# Wi-Fi: Borgernet
# Disk: Wipes all, reclaims full disk

# Language and keyboard
lang da_DK.UTF-8
keyboard dk

# Timezone (Denmark)
timezone Europe/Copenhagen --nontp

# User creation
user --name=superuser --groups=wheel --password=$6$... --iscrypted

# Network
network --onboot yes --device wlan0 --bootproto dhcp --noipv6 --wireless

# Disk layout — wipe all, reclaim full disk
clearpart --all --initlabel
part / --fstype=xfs --size=1 --grow
part /boot --fstype=xfs --size=1024

# Install Silverblue base
%packages
@core
@fedora-silverblue
%end

# Post-install: Optional — inject your container or config
%post
# Example: Pull your OCI image (if needed)
# podman pull ghcr.io/yourusername/your-app:latest
# podman save -o /tmp/your-app.tar ghcr.io/yourusername/your-app:latest
%end

# Reboot after install
reboot

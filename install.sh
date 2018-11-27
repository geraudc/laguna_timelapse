#! /bin/bash

# Excute me as root

# Variables
app_name=laguna_timelapse
install_dir="/opt/laguna_timelapse/"

echo "Laguna timelapse install"

echo "  Create folders"

mkdir -p /opt/laguna_timelapse
mkdir -p /var/log/laguna_timelapse

echo "  Setting up main script"

cp laguna_timelapse.py $install_dir
cp laguna_timelapse_frontend.py $install_dir
cp -r template $install_dir
cp -r static $install_dir
cp dropbox_uploader.sh $install_dir
cp laguna_timelapse_dropbox_clean.sh $install_dir

chmod +x $install_dir/dropbox_uploader.sh
chmod +x $install_dir/laguna_timelapse.py
chmod +x $install_dir/laguna_timelapse_frontend.py
chmod +x $install_dir/laguna_timelapse_dropbox_clean.sh

chown -R pi:pi /opt/laguna_timelapse
chown -R pi:pi /var/log/laguna_timelapse

echo "  Setting up usb key"

#mount /dev/sda1 /media/usb -o uid=pi,gid=pi
mkdir -p /media/usb
chown -R pi:pi /media/usb
usb_uuid=$(ls -l /dev/disk/by-uuid/ | grep sda1 | cut -d " " -f9)
if ! grep -q "$usb_uuid" /etc/fstab ; then
    apt-get --assume-yes install exfat-fuse
    mkdir -p /media/usb
    chown -R pi:pi /media/usb
    cp /etc/fstab ../fstab_backup_$(date +"%m_%d_%Y_%H_%M_%S")
    echo "UUID=${usb_uuid} /media/usb exfat auto,nofail,noatime,users,rw,uid=pi,gid=pi 0 0" >> /etc/fstab
    mount -a
fi

echo "  Setting up service"

if command -v systemctl >/dev/null 2>&1 ; then
# Setting up systemd if exist
    cp laguna_timelapse.service /lib/systemd/system/
    cp laguna_timelapse_frontend.service /lib/systemd/system/
    sync
    chmod 644 /lib/systemd/system/laguna_timelapse.service
    chmod 644 /lib/systemd/system/laguna_timelapse_frontend.service
    systemctl daemon-reload
    systemctl enable laguna_timelapse_frontend
    systemctl stop laguna_timelapse_frontend
    systemctl start laguna_timelapse_frontend
    if [[ $(systemctl is-active laguna_timelapse) == "active" ]]; then
        echo "  Restarting laguna_timelapse"
        systemctl stop laguna_timelapse
        systemctl start laguna_timelapse
    fi
else
# Setting up init.d if systemd doesn't exist
    echo "You need systemd"
    echo "Installation failed"
    exit 1
fi

if [ ! -f ~pi/.dropbox_uploader ]; then
    echo "  First install configuration"
    echo "  Please run $install_dir/dropbox_uploader.sh to configure"
    ## su -c pi ./dropbox_uploader.sh
fi

# Routing port 5000 to 80
# iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5000

echo "Installation done"
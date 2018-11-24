#! /bin/bash

# Excute me as root

# Variables
app_name=laguna_timelapse
install_tmp=laguna_timelapse_install_tmp
install_dir="/opt/laguna_timelapse/"

echo "Laguna timelapse install"

echo "  Create folders"

rm -rf $install_tmp
mkdir $install_tmp
mkdir -p /opt/laguna_timelapse
mkdir -p /var/log/laguna_timelapse
cd $install_tmp

echo "  Download files"

wget -q https://raw.githubusercontent.com/geraudc/laguna_timelapse/master/laguna_timelapse.py 
wget -q https://raw.githubusercontent.com/geraudc/laguna_timelapse/master/laguna_timelapse_frontend.py 
curl -s "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox_uploader.sh

echo "  Setting up main script"

cp laguna_timelapse.py $install_dir
cp laguna_timelapse_frontend.py $install_dir
chmod +x $install_dir/laguna_timelapse.py
chmod +x $install_dir/laguna_timelapse_frontend.py

echo "  Setting up usb key"

#mount /dev/sda1 /media/usb -o uid=pi,gid=pi
usb_uuid=$(ls -l /dev/disk/by-uuid/ | grep sda1 | cut -d " " -f9)
if ! grep -q "$usb_uuid" /etc/fstab ; then
    apt-get --assume-yes install exfat-fuse
    mkdir -p /media/usb
    chown -R pi:pi /media/usb
    cp /etc/fstab ../fstab_backup_$(date +"%m_%d_%Y_%H_%M_%S")
    echo "UUID=${usb_uuid} /media/usb exfat auto,nofail,noatime,users,rw,uid=pi,gid=pi 0 0" >> /etc/fstab
    mount -a
fi

echo "  Setting up dropbox dependency"

cp dropbox_uploader.sh $install_dir
chmod +x $install_dir/dropbox_uploader.sh

echo "  Setting up service"

if command -v systemctl >/dev/null 2>&1 ; then
# Setting up systemd if exist
    wget -q https://raw.githubusercontent.com/geraudc/laguna_timelapse/master/laguna_timelapse.service
    cp laguna_timelapse.service /lib/systemd/system/
    chmod 644 /lib/systemd/system/laguna_timelapse.service
    systemctl daemon-reload
    systemctl enable laguna_timelapse.service
else
# Setting up init.d if systemd doesn't exist
    wget -q https://raw.githubusercontent.com/geraudc/laguna_timelapse/master/laguna_timelapse_init.sh
    cp laguna_timelapse_init.sh /etc/init.d/
    mkdir -p /var/log/$app_name/
    mkdir -p /var/run/$app_name/
    chown -R pi:pi /var/log/$app_name/
    chown -R pi:pi /var/run/$app_name/
    chmod +x /etc/init.d/laguna_timelapse_init.sh
    update-rc.d laguna_timelapse_init.sh defaults
    # sudo update-rc.d -f laguna_timelapse_init.sh remove
fi

if [ ! -f ~pi/.dropbox_uploader ]; then
    echo "  First install configuration"
    echo "  Please run $install_dir/dropbox_uploader.sh to configure"
    ## su -c pi ./dropbox_uploader.sh
fi

echo "Installation done"
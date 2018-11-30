# Laguna Timelapse

Another timelapse for raspberry pi <https://github.com/geraudc/laguna_timelapse.git>

## Prerequists

* python3
* systemd

## Fast install

Latest release is available here : https://github.com/geraudc/laguna_timelapse/releases/latest

```bash
wget <link_to_release.tar.gz
```

Execute this commands :

```bash
tar -xvf <tar_name>
cd laguna_timelapse
sudo ./install.sh
sync
```

You will be able to see the frontend : <http://pi_ip_address>

The app will be installed in the directory </opt/laguna_timelapse/> and
can be launched by ```pi``` user.

If it is your first install and if you want to use dropbox, you will
need to launch dropbox_uploader.sh to get the token.

## Usage

Start timelapse :

```bash
sudo systemctl start laguna_timelapse
```

Stop timelapse :

```bash
sudo systemctl stop laguna_timelapse
```

Start timelapse on boot :

```bash
sudo systemctl enable laguna_timelapse
```

Do not start timelapse on boot :

```bash
sudo systemctl disable laguna_timelapse
```

## Dependencies

* <https://github.com/andreafabrizi/Dropbox-Uploader>

## Install from scratch

Get the last raspbian image and flash it to your sdcard using Win32DiskImager for exemple.

To enable ssh, create a file named ```ssh``` in the boot partition of the sdcard. (<https://www.raspberrypi.org/documentation/remote-access/ssh/>)

Connect to the raspberry pi using ssh and use ```sudo raspi-config``` to
enable the camera (/5/P1/ yes) and set an hostname to your pi. A reboot is needed.

Enable your wifi connection if needed by editing </etc/wpa_supplicant/wpa_supplicant.conf> using the command : ```wpa_passphrase <ssid> [passphrase]```

Launch the file with : ```wpa_cli -i wlan0 reconfigure```

Install some dependencies :

```bash
sudo apt-get update && sudo apt-get --assume-yes upgrade
sudo apt-get --assume-yes install python3-pip python3-dev python3-rpi.gpio imagemagick iptables-persistent
sudo pip3 install flask
sudo pip3 install pillow
```

Enable persistent port redirection.

```bash
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5000
sudo sh -c 'iptables-save > /etc/iptables/rules.v4'
```

You will now be able to install laguna_timelpase using "Fast install" section.

## Development

* Export to target from gitbash : ```./export.sh <tar.get.ip.addr>```

* Check logs in real time
  * ```journalctl -f -u laguna_timelapse```
  * ```journalctl -f -u laguna_timelapse_frontend```

## Bilbiography

* init.d :
  * <https://github.com/wyhasany/sysvinit-service-generator>
* mount usb :
  * <https://www.raspberrypi-spy.co.uk/2014/05/how-to-mount-a-usb-flash-disk-on-the-raspberry-pi/>
  * <https://miqu.me/blog/2015/01/14/tip-exfat-hdd-with-raspberry-pi/>
* port redirection :
  * <https://serverfault.com/questions/112795/how-to-run-a-server-on-port-80-as-a-normal-user-on-linux>
* multiprocessing :
  * <https://stackoverflow.com/questions/6920858/interprocess-communication-in-python>
* imaging :
  * <https://stackoverflow.com/questions/27868250/python-find-out-how-much-of-an-image-is-black>
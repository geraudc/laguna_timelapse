# Laguna Timelapse

Another timelapse for raspberry pi <https://github.com/geraudc/laguna_timelapse.git>

## Prerequists

* python3
* systemd

## Install

Download a release from https://github.com/geraudc/laguna_timelapse/releases/

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
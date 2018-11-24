from flask import Flask, flash, redirect, render_template, request, session, abort
import os
import sys
import socket
import subprocess
import glob
import errno

def symlink_force(target, link_name):
    try:
        os.symlink(target, link_name)
    except OSError as e:
        if e.errno == errno.EEXIST:
            os.remove(link_name)
            os.symlink(target, link_name)
        else:
            raise e

abspath = os.path.abspath(sys.argv[0])
dname = os.path.dirname(abspath)
os.chdir(dname)
print("Working directory : " + dname)

app = Flask(__name__, template_folder='template')
 
@app.route("/")
def index():
    folderToSearch = os.path.join("/media/usb/", socket.gethostname() + "_timelapse/") + "*.jpg"
    listOfFiles = glob.glob(folderToSearch)
    if listOfFiles :
        latestFile = max(listOfFiles, key=os.path.getctime)
        latestFileLink = os.path.join(dname, "static/latest_picture.jpg")
        symlink_force(latestFile, latestFileLink)

    return render_template(
        'laguna_timelapse.html', 
        hostname=socket.gethostname())
 
@app.route("/camera/<string:command>/")
def command(command):
    if command == 'start':
        os.system("sudo systemctl start laguna_timelapse")
        return 'timelapse started'
    elif command == 'stop':
        os.system("sudo systemctl stop laguna_timelapse")
        return 'timelapse stopped'
    elif command == 'status':
        systemctl_status = subprocess.run(['sudo', 'systemctl', 'is-active', 'laguna_timelapse'], stdout=subprocess.PIPE)
        status = systemctl_status.stdout.decode('utf-8')
        systemctl_status_enable = subprocess.run(['sudo', 'systemctl', 'is-enabled', 'laguna_timelapse'], stdout=subprocess.PIPE)
        status_enable = systemctl_status_enable.stdout.decode('utf-8')
        return_str = "timelapse running status " + status + " and startup at boot " + status_enable
        return return_str
    elif command == 'enable':
        #subprocess.run(['sudo', 'systemctl', 'enabled', 'laguna_timelapse'])
        os.system("sudo systemctl enable laguna_timelapse")
        return "timelapse enable"
    elif command == 'disable':
        #subprocess.run(['sudo', 'systemctl', 'disable', 'laguna_timelapse'])
        os.system("sudo systemctl disable laguna_timelapse.service")
        return "timelapse disable"
    else:
        return 'command ok unknown'

@app.route("/test")
def test():
    return 'test route ok'

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)

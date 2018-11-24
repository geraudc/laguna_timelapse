#!/usr/bin/env python
#

import os
import time
import logging
from datetime import datetime
import sys
from subprocess import call
import socket

# Script path
scriptPath = os.path.dirname(sys.argv[0])
scriptAbsPath = os.path.abspath(scriptPath)

# Define the location where you wish to save files. Set to HOME as default. 
# If you run a local web server on Apache you could set this to /var/www/ to make them 
# accessible via web browser.
localTargetFolder = "/media/usb/" + socket.gethostname() +"_timelapse/"

if not os.path.exists(localTargetFolder):
    os.mkdir(localTargetFolder)

# Remote directory
remoteDirectory = os.path.join("laguna_timelapse", socket.gethostname())

# Set up a log file to store activities for any checks.
d = datetime.now()

logging.basicConfig(filename=str(localTargetFolder) + d.strftime("%Y_%m_%d__%H_%M_%S.log"), level=logging.DEBUG)
logging.debug(" Laguna timelapse ")

# Configuration
uploadToDropbox = True
convertPicture = True
waitBetweenPictureInSec = 60
imgWidth = 1920 # Max = 2592 
imgHeight = 1080 # Max = 1944

# Run a WHILE Loop of infinitely
while True :

    d = datetime.now()

    # Create file name and upload target name
    localTargetFile = os.path.join(localTargetFolder, socket.gethostname() + "_" + \
                                d.strftime("%Y_%m_%d__%H_%M_%S.jpg"))
    remoteTargetFile = os.path.join(remoteDirectory, \
                                    socket.gethostname() + "_" + \
                                    d.strftime("%Y_%m_%d__%H_%M_%S.jpg"))

    print("Saving file at " + d.strftime("%Y %m %d %H %M %S"))
    
    # Capturing image
    os.system("raspistill -w " + str(imgWidth) + " -h " + \
                str(imgHeight) + " -o " + localTargetFile + \
                " -rot 270 -ex auto -awb auto -v")

    if convertPicture :
        os.system("convert -resize 50% -pointsize 18 -fill blue " + \
                    " -draw \"text 25,25 '$(date '+%d-%m-%Y %H:%M')'\" " + \
                    str(localTargetFile) + " " + str(localTargetFile))
        logging.debug("Image converted : "+ str(localTargetFile))
        print("Image converted : " + str(localTargetFile))
    
    if uploadToDropbox :
        TheCall = os.path.join(scriptAbsPath, "dropbox_uploader.sh") + \
                " upload " + str(localTargetFile) + " " + str(remoteTargetFile)
        call ([TheCall], shell=True)
        logging.debug('Image uploaded to : ' + str(remoteTargetFile))
        print("Upload done : " + str(remoteTargetFile))
    
    # Wait before next capture in seconds
    time.sleep(waitBetweenPictureInSec)


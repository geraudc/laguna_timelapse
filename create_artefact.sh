#! /bin/bash

cd ..

tar cvf laguna_timelapse/laguna_timelapse.tar \
    laguna_timelapse/laguna_timelapse.py \
    laguna_timelapse/dropbox_uploader.sh \
    laguna_timelapse/favicon.ico \
    laguna_timelapse/laguna_timelapse.py \
    laguna_timelapse/laguna_timelapse.service \
    laguna_timelapse/laguna_timelapse_dropbox_clean.sh \
    laguna_timelapse/laguna_timelapse_frontend.py \
    laguna_timelapse/laguna_timelapse_frontend.service \
    laguna_timelapse/static \
    laguna_timelapse/template \
    laguna_timelapse/install.sh

cd -

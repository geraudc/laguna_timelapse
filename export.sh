#! /bin/bash
tar_name="laguna_timelapse.tar"

./create_artefact.sh

scp $tar_name pi@$1:~/

ssh -t pi@$1 bash -c "'
tar -xvf $tar_name
cd laguna_timelapse
sudo ./install.sh
sync
'"

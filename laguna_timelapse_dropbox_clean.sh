#! /bin/bash

dayold_limit=2
# Get hostname
#hostname=$(hostname)
hostname=raspilondon
filesdates=$(/opt/laguna_timelapse/dropbox_uploader.sh list \
laguna_timelapse/$hostname | grep -Eo \
'[[:digit:]]{4}_[[:digit:]]{2}_[[:digit:]]{2}__[[:digit:]]{2}_[[:digit:]]{2}_[[:digit:]]{2}')

while read -r date_extracted; do
    date_extracted_saved=$date_extracted
    date_extracted=${date_extracted/__/ }
    date_extracted=${date_extracted/_/-}
    date_extracted=${date_extracted/_/-}
    date_extracted=${date_extracted/_/:}
    date_extracted=${date_extracted/_/:}

    t1=$(date -d "${date_extracted}" +%s)

    t2=$(date +%s)
    let "tDiff=$t2-$t1"
    #dayago=$(date -d "${tdiff}" +%d)
    let "dDiff=$tDiff/(3600*24)"

    if [[ $dDiff > $dayold_limit ]]; then
        echo "delete the file $dDiff day old : /laguna_timelapse/$hostname/$hostname_$date_extracted_saved.jpg"
    fi 
done <<< "$filesdates"

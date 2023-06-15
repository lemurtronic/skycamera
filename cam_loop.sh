#!/usr/bin/bash

source .creds
#source settings.file
shutter=10000000 # microseconds

/usr/bin/python3 /home/eyeontheskypi/dawndusk.py

while :
do
  source dawndusk.txt

  if [[ $(date +%s) < $(($(date -d "$Dawn" +%s) + 84600)) && $(date +%s) > $(date -d "$Dusk" +%s) ]]
  then
    libcamera-still --shutter $shutter -e png -o images/snapshot.png --width 2028 --height 1520 --immediate

    sleep $(( 50 - $shutter/1000000 ))

  else
    libcamera-still -e png -o images/snapshot.png --width 2028 --height 1520 --immediate

    sleep 55 
  fi

    # Get time/date now
    time_date_now=$(date +%Y%m%d%H%M%S)

    # Add the date to the image
    convert images/snapshot.png -pointsize 48 -fill white -undercolor '#00000080' -gravity SouthWest -annotate +10+10 "$(date)" images/$time_date_now.png

    # Convert to JPEG for uploading
    convert images/$time_date_now.png images/current.jpg

    # Upload the image to the website
sshpass -p $sftp_pass sftp u350931518@home349728106.1and1-data.host <<EOF
put images/current.jpg
bye
EOF
done

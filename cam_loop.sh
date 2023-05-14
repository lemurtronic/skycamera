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
    libcamera-still --shutter $shutter --gain 1.5 -e png -o images/snapshot.png --immediate
   #libcamera-still --shutter $shutter -e png -o images/snapshot.png --width 1024 --height 760 --immediate

    sleep $(( 30 - $shutter/1000000 ))

  else
   #libcamera-still -e png -o images/snapshot.png --width 800 --height 600 --immediate
    libcamera-still -e png -o images/snapshot.png --immediate

    sleep 25 
  fi
    # Copy the file to the images folder, for processing later
    cp images/snapshot.png images/$(date +%Y%m%d%H%M%S).png

    # Add the date to the image
    convert images/snapshot.png -pointsize 12 -fill white -undercolor '#00000080' -gravity SouthWest -annotate +10+10 "$(date)" images/current.jpg

    # Upload the image to the website
sshpass -p $sftp_pass sftp u350931518@home349728106.1and1-data.host <<EOF
put images/current.jpg
bye
EOF
done

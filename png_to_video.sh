#!/usr/bin/bash

source .creds

ffmpeg -y -r 2 -pattern_type glob -i 'images/*.png' -vf scale=480:-2,setsar=1:1 -c:v libx264 -c:a aac -pix_fmt yuv420p video/$(date +%Y%m%d).mp4

cp video/$(date +%Y%m%d).mp4 video/yesterday.mp4

ffmpeg -y -i video/yesterday.mp4 video/yesterday.webm

#rm -f images/*

sshpass -p $sftp_pass sftp u350931518@home349728106.1and1-data.host <<EOF
put video/yesterday.webm
bye
EOF


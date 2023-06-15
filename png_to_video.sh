#!/usr/bin/bash

source .creds

ffmpeg -y -r 4 -pattern_type glob -i 'images/*.png' -vf scale=480:-2,setsar=1:1 -c:v libx264 -pix_fmt yuv420p video/$(date +%Y%m%d).mp4

cp video/$(date +%Y%m%d).mp4 video/yesterday.mp4


rm -f images/*

sshpass -p $sftp_pass sftp u350931518@home349728106.1and1-data.host <<EOF
put video/yesterday.mp4
bye
EOF


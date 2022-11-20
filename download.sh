#!/usr/bin/bash

# makeiso URL1 URL2 ISO
makeiso(){
  tmp=`mktemp -d`

  # Download .mp4s with captions embedded
  yt-dlp "$1" -f 22 --write-auto-subs --embed-subs -o $tmp/vid1.mp4
  yt-dlp "$2" -f 22 --write-auto-subs --embed-subs -o $tmp/vid2.mp4

  # Convert to .mpg with rendered subtitles
  ffmpeg -i $tmp/vid1.mp4 -vf subtitles=$tmp/vid1.mp4 -target pal-dvd $tmp/vid1.mpg
  ffmpeg -i $tmp/vid2.mp4 -vf subtitles=$tmp/vid2.mp4 -target pal-dvd $tmp/vid2.mpg

  # Add both as titles and finalize DVD
  dvdauthor -o $tmp/dvd/ -t $tmp/vid1.mpg
  dvdauthor -o $tmp/dvd/ -t $tmp/vid2.mpg
  dvdauthor -o $tmp/dvd/ -T

  # Create iso
  mkisofs -dvd-video -o $3 $tmp/dvd/

  rm -rf $tmp
}

set -x
makeiso https://www.youtube.com/watch?v=TR5nd0bjb_I https://www.youtube.com/watch?v=zoyZ1Kga-YI out.iso
#!/usr/bin/env bash

set -e

outputfile(){
  name=out
  if [[ -e $name.iso || -L $name.iso ]] ; then
    i=0
    while [[ -e $name-$i.iso || -L $name-$i.iso ]] ; do
      let i++
    done
    name=$name-$i
  fi
  touch -- "$name".iso
  echo "$name.iso"
}

# makeiso URL1 URL2 ISO
makeiso(){
  # tmp=`mktemp -d`
  tmp="./tmp"

  # Can be useful for testing. Make sure you disable the rm -rf $tmp at the end of the function.
  # tmp=$(pwd)

  # Download .mp4s with captions embedded
  yt-dlp "$1" -f b --write-auto-subs --embed-subs -o $tmp/vid1.mp4
  yt-dlp "$2" -f b --write-auto-subs --embed-subs -o $tmp/vid2.mp4

  # Convert to .mpg with rendered subtitles
  ffmpeg -i $tmp/vid1.mp4 -vf subtitles=$tmp/vid1.mp4 -target ntsc-dvd $tmp/vid1.mpg
  ffmpeg -i $tmp/vid2.mp4 -vf subtitles=$tmp/vid2.mp4 -target ntsc-dvd $tmp/vid2.mpg

  # Add both as titles and finalize DVD
  dvdauthor -o $tmp/dvd/ -t $tmp/vid1.mpg
  dvdauthor -o $tmp/dvd/ -t $tmp/vid2.mpg
  dvdauthor -o $tmp/dvd/ -T

  # Create iso
  mkisofs -dvd-video -o $(outputfile) $tmp/dvd/

  rm -rf $tmp
}

# Take two files at a time and write DVDs
file1=0
for url in $(cat $1); do
  if [ $file1 == 0 ]
  then
    file1=$url
  else
    makeiso $file1 $url
    file1=0
  fi
done

# Write last file
if [ $file1 ]
then
  makeiso $file1 ""
fi

echo "write iso to disk with growisofs -dvd-compat -Z /dev/dvd=no-captions.iso"

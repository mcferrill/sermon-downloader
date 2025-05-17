FROM ubuntu:noble
RUN apt update && apt install -y python3-pip ffmpeg dvdauthor genisoimage growisofs
COPY yt-dlp /root
COPY download.sh /root

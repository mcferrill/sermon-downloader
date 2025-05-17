FROM ubuntu:noble
RUN apt update && apt install -y python3-pip ffmpeg dvdauthor genisoimage growisofs
RUN pip3 install yt-dlp
COPY download.sh /root

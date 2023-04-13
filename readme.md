
# Sermon Downloader

Utility to create DVD ISOs with captions. Takes a file with a list of youtube URLs and outputs a series of ISOs (two videos per ISO).

## Dependencies

Install via apt/homebrew/etc.

* yt-dlp
* ffmpeg
* dvdauthor
* mkisofs
* growisofs (for writing to disk)

## Using on unraid

### Download

**Note:** I'm using the ripper app on my server and have to turn it off to burn disks.

Start container (and keep running) with:

    docker run -dt -v /path/to/share:/root/unraid --cpuset-cpus=2,3 mcferrill/sermon-downloader sleep infinity

**Note:** Includes specifying 2 CPUs. Adjust as needed.

In container shell, run:

    cd ~
    ./download.sh ./unraid/sermons.txt > log.txt

You can then monitor progress by monitoring log.txt

### Burn

**Note:** requires running the container with `--privileged` option. Use at your own risk.

    growisofs -dvd-compat -Z /dev/dvd=mydisc.iso

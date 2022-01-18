# ffmpegTrimTool
Cut multiple parts of video easily with ffmpeg

## Usage
Write comma separated list of times in cuts.txt in HH:MM:ss format.
Do not include trailing zeros, e.g ~~01:02:03~~ but 1:2:3 is ok.

./cut.sh input.mp4 outout.mp4

The video will be re-encoded so it will take long for large videos,
but the cut times are precise.

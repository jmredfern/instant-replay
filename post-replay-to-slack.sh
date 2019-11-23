touch /Users/jimredfern/Movies/log
echo \[`date`\] "sh started" >> /Users/jimredfern/Movies/log

filepath=$1
index=$2

mv "$filepath" /Users/jimredfern/Movies/fullspeed-no-overlay-$index.mov

echo \[`date`\] "completed mv to fullspeed no overlay" >> /Users/jimredfern/Movies/log

# /usr/local/bin/mpv --screen=1 --fs --fs-screen=1 --external-file /Users/jimredfern/Movies/replay_overlay.png /Users/jimredfern/Movies/fullspeed-no-overlay-$index.mov /Users/jimredfern/Movies/fullspeed-no-overlay-$index.mov --lavfi-complex "[vid1][vid2]overlay@myoverlay[vo]"

/bin/bash -c "/usr/local/bin/mpv --screen=1 --fs --fs-screen=1 --external-file /Users/jimredfern/Movies/replay_overlay.png /Users/jimredfern/Movies/fullspeed-no-overlay-$index.mov /Users/jimredfern/Movies/fullspeed-no-overlay-$index.mov --lavfi-complex \"[vid1][vid2]overlay@myoverlay[vo]\""

echo \[`date`\] "completed mpv play" >> /Users/jimredfern/Movies/log

/usr/local/bin/ffmpeg -i /Users/jimredfern/Movies/fullspeed-no-overlay-$index.mov -i /Users/jimredfern/Movies/replay_overlay.png -filter_complex "[0:v][1:v] overlay=0:0:enable='between(t,0,20)'" -pix_fmt yuv420p -c:a copy /Users/jimredfern/Movies/fullspeed-$index.mov -vcodec hevc_videotoolbox
/usr/local/bin/ffmpeg -i /Users/jimredfern/Movies/fullspeed-$index.mov -filter:v "setpts=1.5*PTS" -filter:a "atempo=0.75" /Users/jimredfern/Movies/halfspeed-$index.mov -vcodec hevc_videotoolbox
touch filelist-$index
echo "file 'fullspeed-${index}.mov'" > /Users/jimredfern/Movies/filelist-$index
echo "file 'halfspeed-${index}.mov'" >> /Users/jimredfern/Movies/filelist-$index
/usr/local/bin/ffmpeg -f concat -safe 0 -i /Users/jimredfern/Movies/filelist-$index -c copy /Users/jimredfern/Movies/TS-SF-pingpong-replay-$index.mov -vcodec hevc_videotoolbox
rm /Users/jimredfern/Movies/filelist-$index
curl -F "file=@/Users/jimredfern/Movies/TS-SF-pingpong-replay-$index.mov" -F channels=sf-pingpong-replay -H "Authorization: Bearer xoxb-2189448013-837079926151-rrqiok29Jh9bSpej4S8COqDX" https://slack.com/api/files.upload
rm /Users/jimredfern/Movies/*-$index.mov
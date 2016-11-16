#!/bin/bash
#
# A relatively simple script for taking a mumble recording and converting it to a podcast
#
# Requires that you have sox installed.
#
# Usage: $ mumble2podcast.sh 

echo "what is the name of the sourceaudio file"

read sourceaudio

echo "what is the episode number?"

read episode_number

echo "what were some of the podcast topics?"

read topics

introaudio="intro.wav" #XXX Assumes intro.wav is in the local directory
outroaudio="outro.wav" #XXX Assumes outro.wav is in the local directory

echo "Truncating silence from $sourceaudio to $sourceaudio.truncated.wav"

sox -S $sourceaudio $sourceaudio.truncated.wav silence 1 0.1 0% -1 0.1 0%

echo "Homogenizing sample rates to 48000 Hz"

sox -S $sourceaudio.truncated.wav -r 48000 $sourceaudio.48kHz.wav

echo "Adding Intro and Outro... and encoding to OGG"

sox -S intro.wav $sourceaudio.48kHz.wav outro.wav lugcast_${episode_number}.ogg

sox -S lugcast_${episode_number}.ogg lugcast_${episode_number}.mp3

echo "Cleaning up breadcrumbs."

rm $sourceaudio.truncated.wav
rm $sourceaudio.48kHz.wav

echo "adding media tags"

date=($date +'%Y')

./fix_tags  -ARTIST=LinuxLugCast -TITLE=lugcast_${episode_number} -COMMENT="$topics" -ALBUM=LinuxLUGcast_Podcast -TRACK=001 -GENRE=podcast -YEAR=$date lugcast_${episode_number}.*

echo "All done time to post"

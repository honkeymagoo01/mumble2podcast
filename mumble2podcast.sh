#!/bin/bash

# A relatively simple script for taking a mumble recording and converting it to a podcast
#
# Requires that you have sox installed.
#
# Usage: $ mumble2podcast.sh <input_file.wav>

sourceaudio=$(basename "$1")
introaudio="intro.wav" #XXX Assumes intro.wav is in the local directory
outroaudio="outro.wav" #XXX Assumes outro.wav is in the local directory

echo "Truncating silence from $1 to $sourceaudio.truncated.wav"

sox -S $1 $sourceaudio.truncated.wav silence 1 0.1 0% -1 0.1 0%

echo "Homogenizing sample rates to 48000 Hz"

sox $sourceaudio.truncated.wav -r 48000 $sourceaudio.48kHz.wav

echo "Adding Intro and Outro... and encoding to OGG"

sox intro.wav $sourceaudio.48kHz.wav outro.wav $sourceaudio.ogg #XXX Might be nice to specify the output at the command line

echo "Cleaning up breadcrumbs."

rm $sourceaudio.truncated.wav
rm $sourceaudio.48kHz.wav

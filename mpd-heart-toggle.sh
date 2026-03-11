#!/bin/bash

# When toggling the heart, to add or remove a song from the playlist, the script 
# which does the visual toggle gets the change signal from the user and updates 
# the heard to the corresponding icon.

PLAYLIST_NAME="I love these"

song=$(mpc --format %file% current)

[[ -z "$song" ]] && exit 0

# Find position of song in playlist
pos=$(mpc --format %file% playlist "$PLAYLIST_NAME" | grep -nFx "$song" | cut -d: -f1)

if [[ -n "$pos" ]]; then
    mpc delplaylist "$PLAYLIST_NAME" "$pos"
else
    mpc addplaylist "$PLAYLIST_NAME" "$song"
fi

#!/bin/bash  


# For understanding the status in mpc:
# - A song is playing or paused meaning i can see current song via "mpc current"
# - If the music is off, the when checking if there is a song, i get nothing.

PLAYLIST_NAME="I love these"

while true; do
	current_song=$(mpc --format %file% current)

	if [[ -n "$current_song" ]]; then
		# Music is on
		if mpc --format %file% playlist "$PLAYLIST_NAME" | grep -Fxq "$current_song";
		then
		    # found
		    printf " \n"
		else
		    # not found
		    printf " \n"
		fi
	else
		# Music is off
		
		printf "\n"  # Print nothing, expected behavior is shrink of module size.
	fi

	# Start waiting for a change of a song (user input)
	mpc idle player playlist stored_playlist > /dev/null
done












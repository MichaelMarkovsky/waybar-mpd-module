#!/bin/bash  

echo "Loading.."
# We have 3 modes:
# 1. We do not play anything
#	Example:
#		volume: n/a   repeat: off   random: off   single: off   consume: off
#
# 2. We currently play a song
# 	Example:
#		Falling in Reverse - Goddamn
#		[playing] #20/71   0:09/3:10 (4%)
#		volume: 48%   repeat: off   random: off   single: off   consume: off
#
# 3. The song that we play is at pause
#	Example:
#		Falling in Reverse - Goddamn
#		[paused]  #20/71   0:06/3:10 (3%)
#		volume: 48%   repeat: off   random: off   single: off   consume: off

# This function is in essense a marquee effect of the text:

WIDTH=25
MODULE_WIDTH=29

# Nerd font icons
PREFIX_PLAY=" | "
PREFIX_PAUSE=" | "
PREFIX_STOP=" | "
STOP_TEXT="Music Off"

WIDTH_PLAY=$((WIDTH + ${#PREFIX_PLAY}))
WIDTH_PAUSE=$((WIDTH + ${#PREFIX_PAUSE}))
WIDTH_STOP=$((WIDTH + ${#PREFIX_STOP}))


function animation(){
	local current_song="$1"
	local prefix="$2"
	local idle_pid="$3"
	local total_width="$4"

	function slice_loop () { ## grab a slice of a string, and if you go past the end loop back around
	    local str="$1"
	    local start=$2
	    local how_many=$3
	    local len=${#str};

	    local result="";

	    for ((i=0; i < how_many; i++))
	    do
		local index=$(((start+i) % len)) ## Grab the index of the needed char (wrapping around if need be)
		local char="${str:index:1}" ## Select the character at that index
		local result="$result$char" ## Append to result
	    done

	    echo -n "$result"
	}

	msg="${current_song} ";
	begin=0

	while kill -0 "$idle_pid" 2>/dev/null;
	do
	    slice=$(slice_loop "$msg" "$begin" "$WIDTH");
	    printf "%-${MODULE_WIDTH}s\n" "${prefix}${slice}"
	    sleep 0.30;
	    ((begin=begin+1));
	done
}



# From the examples above, if status contains:
# 1 line => Stopped
# 3 lines => either playing or paused
function current_status(){

	get_status=$(mpc status)

	mpc_status_lines=$(echo "$get_status" | wc -l)
	mpc_second_line=$(echo "$get_status" | sed -n '2 p')
	mpc_status=""

	if [ "$mpc_status_lines" -eq 1 ]; then
		mpc_status="stopped"
	fi

	# If the status has 3 lines and contains [playing] at the second line, the its playing.
	if [ "$mpc_status_lines" -eq 3 ]; then
		if [[ $mpc_second_line == *"[playing]"* ]]; then
			mpc_status="playing"
		fi
		if [[ $mpc_second_line == *"[paused]"* ]]; then
			mpc_status="paused"
		fi
	fi
	echo "$mpc_status"
}

# Act and check for differences only when the state has changed via user action.
while true; do
	
	mpc idle player > /dev/null &
        idle_pid=$!

	status=$(current_status)
	# Here I seperate the 3 type of options, and use the animation if i have a song playing or paused.
	case "$status" in
	  "playing")
		current_song=$(mpc current)

		# escape markup characters
		current_song=${current_song//&/and}
		current_song=${current_song//</}
		current_song=${current_song//>/}

		animation "$current_song" "${PREFIX_PLAY}" "$idle_pid" "${WIDTH_PLAY}"
	   ;; 
	 "paused")
	   	current_song=$(mpc current)
		
		# escape markup characters
		current_song=${current_song//&/and}
		current_song=${current_song//</}
		current_song=${current_song//>/}

		animation "$current_song" "${PREFIX_PAUSE}" "$idle_pid" "${WIDTH_PAUSE}"

           ;;
	 "stopped")
		printf "%s%s\n" "${PREFIX_STOP}" "${STOP_TEXT}"
		wait $idle_pid
	   ;;
	 *)
	   echo "Error: check mpc full status."
	   wait $idle_pid
	   ;;
	esac
	
	
done



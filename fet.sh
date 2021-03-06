#!/usr/bin/env bash

echo

# Main function
# Edit/remove function calls here according to your preferences
get_info() {
	get_user
	get_os
	get_wm
	get_pkg
	get_term
	get_colors
}

# Format and output each entry
output() {
	c="\e[0m"
	c1="\e[32;1m"
	title=$1
	info=$2

	printf " ${c1}${title}:${c}	"
	printf "%12.30s" ${info}
	printf "\n"
}
# user informations
get_user() {
	title="user"
	user=$(users)
		output $title $user
}

# Distro informations
get_os() {
	title="os"
	os=$(uname -o)
	host=$(uname -n)

	# Modify the "os" declaration to your needs
	case $os in
		"GNU/Linux") # check for generic pitfall
			os=$(grep 'DISTRIB_ID=\(\w\+\)' /etc/lsb-release)
			os=${os/*=}
			os=${os,,}
			output $title $os
		;;

		*) # catch others
			output $title $os
		;;
	esac
}

# WM
# Adapted from neofetch function
get_wm() {
	title="wm"

	id=$(xprop -root -notype _NET_SUPPORTING_WM_CHECK)
	id=${id##* }
	wm="$(xprop -id "$id" -notype -len 100 -f _NET_WM_NAME 8t)"

	# Split name from inside double quotes
	wm="${wm/*\ \"}" 
	wm="${wm/\"*}"

	# Check if i3-gaps is used
	if [[ $wm == "i3" ]]; then 
		if [[ $(pacman -Qs i3-gaps) ]]; then
			wm="i3-gaps"
		fi
	fi
	output $title $wm
}

# Packages
# Get the number of packages from pacman
# Edit the the 'pacman -Qq | wc -l' line if you use another package manager than pacman
# "wc -l" counts the number of lines, thus the number of packages
get_pkg() {
	title="pkgs"
	count="$(pacman -Qq | wc -l)"

	output $title $count
}

# Terminal
# Get the current terminal process id and match it
get_term() {
	title="term"
	pid=$(ps -h -o ppid)
	ppid=$(ps -h -o comm -p $pid)

	case "$ppid" in
		alacritty*)
			term="alacritty"
			;;
		kitty*)
			term="kitty"
			;;
		xterm*)
			term="xterm"
			;;
		konsole*)
			term="konsole"
			;;
		gnome-terminal*)
			term="gnome terminal"
			;;
		terminator*)
			term="terminator"
			;;
		rxvt*)
			term="rxvt"
			;;
		rxvt-unicode*)
			term="urxvt"
			;;
	esac

	output $title $term
}

# Colors
# Prints the terminal colors
get_colors() {
	c="\e[0m"
	c0="\e[30m"
	c1="\e[31m"
	c2="\e[32m"
	c3="\e[33m"
	c4="\e[34m"
	c5="\e[35m"
	c6="\e[36m"
	c7="\e[37m"
	sym="\u25b2"
	sym1="\u25bc"

	printf "\n    ${c1}${sym} ${c2}${sym1} ${c3}${sym} ${c4}${sym1} ${c5}${sym} ${c6}${sym1} ${c7}${sym}${c}\n"
}

# Main function call
get_info
echo

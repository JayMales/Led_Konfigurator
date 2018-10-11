#!/bin/bash

LEDS="cd /sys/class/leds"
CURRENTSELECT="$1"
PROCESS="$2"
CPURAM="$3"

# Uses ps to find the memory/cpu usage or search for the process name. Sums up all the usage together then prints sends it to an array
# Then does some maths on the usage to find out how much it should flash. Sleeps based off the usage
checkPS(){
	PSUNSORTEDSTRING="`ps -eo comm,%$CPURAM --no-headers --sort comm| grep $PROCESS | awk '{sum+=$NF} END {printf "%s %s\n" ,$1,sum}'`"
	PSUNSORTED=($PSUNSORTEDSTRING)
	USAGE=${PSUNSORTED[-1]}
	# This finds the usage out of 100% then +1 so no div from 0. Then divided by 100 so I get 0-10 input. 
	# It then -11 from that so 1 becomes -10 and 10 becomes -1. Then finally times by -1 which makes it a pos number again
	# So if it is under full load, it will flash every 0.1 seconds and under 10% load it will flash every second (on and off) 
	USAGE=`bc <<< "((($USAGE+1)/100 -11)* -1)/10"`
	`$LEDS/$CURRENTSELECT/ && echo "1" >brightness`
	sleep 0.2
	`$LEDS/$CURRENTSELECT/ && echo "0" >brightness`
	sleep $USAGE
}

# just loops the checkPS function
keepMeALive(){
	while :; do
		checkPS
	done
}

keepMeALive

#!/bin/bash

LEDS="cd /sys/class/leds"
CURRENTSELECT="$1"
PROCESS="$2"
CPURAM="$3"


checkPS(){
	PSUNSORTEDSTRING="`ps -eo comm,%$CPURAM --no-headers --sort comm| grep $PROCESS | awk '{sum+=$2} END {printf "%s %s\n" ,$1,sum}'`"
	PSUNSORTED=($PSUNSORTEDSTRING)
	USAGE=${PSUNSORTED[-1]}
	USAGE=`bc <<< "($USAGE+1)/50"`
	`$LEDS/$CURRENTSELECT/ && echo "1" >brightness`
	sleep $USAGE
	`$LEDS/$CURRENTSELECT/ && echo "0" >brightness`
	sleep $USAGE
}

keepMeALive(){
	while :; do
		checkPS
	done
}

keepMeALive
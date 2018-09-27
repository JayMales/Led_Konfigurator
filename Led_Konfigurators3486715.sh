#!/bin/bash

LEDS="cd /sys/class/leds"
COUNT=0
INPUT=0
VAILD=true
CURRENTSELECT=""

counter(){
	((COUNT+=1))
}

inputTest(){
	re="^[0-9]*$"
	if [[ $INPUT =~ $re && $INPUT -le $COUNT ]];then 
		VAILD=true
	else 
		VAILD=false
	fi
}

menuPrinter(){
	TITLES=("${!1}")
	OPTIONS=("${!2}")
	END=false
	while ! $END; do
		for test in "${TITLES[@]}";do
			echo $test
		done
		
		COUNT=0
		for OPTION in "${OPTIONS[@]}"; do
			counter
			echo $COUNT")"$OPTION
		done
		echo -n "Please enter a number (1-$COUNT):for the option to configure: "
		read INPUT
		inputTest
		if $VAILD;then END=true; else END=false; 
			echo "Invaild input, Please try again"; fi
		echo
	done
}

task5(){
	while :;do
		#SETTHIS=`$LEDS/$CURRENTSELECT/ && echo "heartbeat" >trigger`
		THETRIGGERS=`$LEDS/$CURRENTSELECT/ && cat trigger`
		TITLE=("Associate Led with a system Event"
			"================================="
			"Available events are:" "---------------------")
		OPTIONS=("${THETRIGGERS[@]}" "Quit")
		menuPrinter TITLE[@] OPTIONS[@]
		if [[ "$INPUT" == "$COUNT" ]];then break; fi
	done
}

task3(){
	while :;do
		TITLE=($CURRENTSELECT "==========")
		OPTIONS=("Turn on" "Turn off" "Associate with a system event" 
		"Associate with the performance of a process" 
		"Stop association with a process’ performance" "Quit to main menu")
		menuPrinter TITLE[@] OPTIONS[@]
		if [[ "$INPUT" == "$COUNT" ]];then break; fi
		task5
	done
}

task1(){
	reset
	while :;do
		NAMES=(`$LEDS && ls`)
		TITLE=("Welcome to Led_Konfigurator!" 
		"============================" "Please select an led to configure: ")
		OPTIONS=("${NAMES[@]}" "Quit")
		menuPrinter TITLE[@] OPTIONS[@]
		if [[ "$INPUT" -eq "$COUNT" ]]
		then
			echo "Cya Later Boii"
			exit 0
		fi
		CURRENTSELECT=${NAMES[$INPUT-1]}
		task3
	done
}

task1
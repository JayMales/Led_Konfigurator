#!/bin/bash

#############################################
#											#
#			Led Konfigurator				#
#				Made by						#
#		  Jay Males - s3486715              #
# 											#
#	This script allows a user to edit what  #
#	  the leds to on their pi/keyboard.		#
#	This program was written for COSC1133	#
#											#
#############################################

# Global variables used throughtout the code 
LEDS="cd /sys/class/leds"
MORE="/bin/more"
COUNT=0
INPUT=0
VAILD=true
CURRENTSELECT=""

# This is basically an incrementor for the variable counter 
# could also be written as let count++ 
counter(){
	((COUNT+=1))
}

# This code validates the input for the menu
# only accepts numbers that aren't 0 and are less then the count var 
inputTest(){
	re="^[0-9]*$"
	if [[ $INPUT =~ $re && $INPUT -le $COUNT && $INPUT -ne 0 ]];then 
		VAILD=true
	else 
		VAILD=false
	fi
}

# This is a global printer that prints the menu for the other functions
# It takes two arrays as args then makes them into one array with a counter
# Then it prints the array using one line so I could use "more"
# More is for the pagers if the menu is to big and scrolls off the screen
# It reads input the sends it to inputTest.
# if the input is not vaild, it loops back through the menu and vailation
menuPrinter(){
	TITLES=("${!1}")
	OPTIONS=("${!2}")
	END=false
	while ! $END; do
		PRINTER=()
		for TITLE in "${TITLES[@]}";do
			PRINTER+=("$TITLE")
		done
		COUNT=0
		for OPTION in "${OPTIONS[@]}"; do
			counter
			PRINTER+=("$COUNT)$OPTION")
		done
		
		printf '%s\n' "${PRINTER[@]}"|"$MORE"
		printf "Please enter a number (1-$COUNT) for the option to configure: "
		read INPUT
		inputTest
		if $VAILD;then END=true; else END=false; 
			echo " Invaild input, Please try again"; fi
		echo
	done
}

# Gets the triggers file for the led you have picked. Then creates array to send to menu printer
# After getting the input is back it sets the led to the appropriate setting.
task5(){
	# I used sed to clean up the cat output. It replaces spaces with \n, [ with nothing, ] with * then turns it into an array
	THETRIGGERS=`$LEDS/$CURRENTSELECT/ && cat trigger | sed -e 's/\s/ \n/g;s/\[//g;s/\]/\*/g' |tr "\n" " "`
	THETRIGGERSARRAY=($THETRIGGERS)
	TITLE=("Associate Led with a system Event"
		"================================="
		"Available events are:" "---------------------")
	OPTIONS=("${THETRIGGERSARRAY[@]}" "Quit to previous menu")
	menuPrinter TITLE[@] OPTIONS[@]
	if [[ "$INPUT" != "$COUNT" ]];then 
		CURRTRIGGER=${THETRIGGERSARRAY[$INPUT-1]}
		SETTHIS=`$LEDS/$CURRENTSELECT/ && sudo echo $CURRTRIGGER >trigger`
		echo -e $CURRTRIGGER" is now enabled for "$CURRENTSELECT"\n"
	fi
}

# Creates the menu for task3, sends to menuprinter, based on the input, turns on the led, turns it off
# Or sends you to the next menu. 
task3(){	
	while :;do
		TITLE=($CURRENTSELECT "==========")
		OPTIONS=("Turn on" "Turn off" "Associate with a system event" 
		"Associate with the performance of a process" 
		"Stop association with a process’ performance" "Quit to main menu")
		menuPrinter TITLE[@] OPTIONS[@]
		if [[ "$INPUT" == "$COUNT" ]];then break; fi
		case $INPUT in
			1)
				TURN_ON=`$LEDS/$CURRENTSELECT/ && sudo echo "1" >brightness`
				echo -e $CURRENTSELECT" is now on!\n"
				;;
			2)
				TURN_OFF=`$LEDS/$CURRENTSELECT/ && sudo echo "0" >brightness`
				echo -e $CURRENTSELECT" is now off!\n"
				;;
			3)
				task5
				;;
			4)
				echo -e "This is done yet\n"
				;;
			5) 
				echo -e "This is done yet\n"
				;;
		esac
	done
}

# Clears screen, Gets all the folders in /sys/class/leds/ and creates and array using them. 
# Sends to menuPrinter, sets global var then sends you to the next menu or exits
task2(){
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

task2

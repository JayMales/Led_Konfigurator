#!/bin/bash

LEDS="cd /sys/class/leds"
MORE="/bin/more"
COUNT=0
INPUT=0
VAILD=true
CURRENTSELECT=""

counter(){
	((COUNT+=1))
}

inputTest(){
	re="^[0-9]*$"
	if [[ $INPUT =~ $re && $INPUT -le $COUNT && $INPUT -ne 0 ]];then 
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

task5(){
	while :;do
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
			echo $CURRTRIGGER" is now enabled for "$CURRENTSELECT 
			echo
			break
		else
			break
		fi
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
		case $INPUT in
			1)
				TURN_ON=`$LEDS/$CURRENTSELECT/ && sudo echo "1" >brightness`
				echo $CURRENTSELECT" is now on!"
				echo
				;;
			2)
				TURN_OFF=`$LEDS/$CURRENTSELECT/ && sudo echo "0" >brightness`
				echo $CURRENTSELECT" is now off!"
				echo
				;;
			3)
				task5
				;;
			4)
				echo "This is done yet"
				echo
				;;
			5) 
				echo "This is done yet" 
				echo
				;;
		esac
	done
}

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
#!/bin/bash

leds="cd /sys/class/leds"
count=0

counter(){
	count=$(($count++))
}

task5(){
	setthis=`$leds/$1/ && echo "heartbeat" >trigger`
	theTriggers=`$leds/$1/ && cat trigger`
	count=1
	echo "Associate Led with a system Event
=================================
Available events are: 
---------------------"
	for trigger in $theTriggers
	do
		counter
		echo $count $trigger
	done
	echo
}

task3(){
	ledName=$1
	options=("turn on" "turn off" "associate with a system event" 
	"associate with the performance of a process" 
	"stop association with a process’ performance" "quit to main menu")
	count=1
	echo $ledName
	echo ==========
	for option in "${options[@]}";
	do
		counter
		echo $count $option
	done
	echo "Please enter a number (1-6) for your choice:"
	echo
	task5 $ledName
}

names=`$leds && ls`

echo "Welcome to Led_Konfigurator!
============================
Please select an led to configure: "
count=1
for name in $names
do
	counter
	echo $count $name
	task3 $name
done
counter
echo $count "Quit"
echo "Please enter a number (1-$count):for the led to configure or quit:"

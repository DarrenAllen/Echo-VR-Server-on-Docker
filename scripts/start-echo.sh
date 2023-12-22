#!/bin/bash
#here you need to set the parameters you want to run echo with
#Regions
#"uscn", // US Central North (Chicago)
#"us-central-2", // US Central South (Texas)
#"us-central-3", // US Central South (Texas)
#"use", // US East (Virgina)
#"usw", // US West (California)
#"euw", // EU West 
#"jp", // Japan (idk)
#"sin", // Singapore oce region
region='euw'
flags="-noovr -server -headless -timestep 120 -fixedtimestep -nosymbollookup -logpath logs/$HOSTNAME -serverregion $region"

#create the Log directory 
mkdir /ready-at-dawn-echo-arena/logs/$HOSTNAME/old 2> /dev/null
#move old log files
mv /ready-at-dawn-echo-arena/logs/$HOSTNAME/*.log /ready-at-dawn-echo-arena/logs/$HOSTNAME/old

#export the DISPLAY to a virtual display
export DISPLAY=:0.0 # Select screen 0.0
#start the echo server process
nohup /usr/bin/wine /ready-at-dawn-echo-arena/bin/win10/echovr.exe $flags &

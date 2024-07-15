#!/bin/bash
# Usage: ./script.sh logpath
# Example: ./script.sh "/ready-at-dawn-echo-arena/logs/$HOSTNAME/*.log"

# Command-line argument 1 is the instance number
instance=$1
logpath="/ready-at-dawn-echo-arena/logs/$HOSTNAME/$instance/*.log"

delayToKillServer=1200 #in seconds
waitingForChange=0


function checkForStuckServer {
    echo "checkForStuckServer with logpath $logpath"
    waitingForChange=1
    timeSinceStart=$(awk '{print $1}' /proc/uptime)
    lastLine=$(tail -1 $logpath)
    while :
    do
        if ! [ -f $logpath ]
        then
            echo "no file"
            waitingForChange=0
            return
        fi
        if ! [[ "$(tail -1 $logpath)" == "$lastLine" ]]
        then
            echo "different"
            waitingForChange=0
            return
        else
            totalTime=$(echo "$timeSinceStart + $delayToKillServer" | bc | awk '{print int($1)}')
            systemUptime=$(awk '{print int($1)}' /proc/uptime)

            if [[ $totalTime -le $systemUptime ]]
            then                
                if [[ "$(tail -1 $logpath)" == "$lastLine" ]]
                then
                    pidfile="/ready-at-dawn-echo-arena/pids/$instance.pid"
                    # get the correct pid for this instance
                    pid=$(cat $pidfile)
                    echo "killing pid $pid"
                    #kill the process and log the reason
                    kill $pid
                    echo $(date)": Process killed. Reason: Stuck Server: " $lastLine >> /ready-at-dawn-echo-arena/logs/$HOSTNAME/errorlog
                    waitingForChange=0
                    return
                fi
            fi
            
        fi
        sleep 2
    done
    
}

while :
do
    echo $waitingForChange
    if [[ $waitingForChange -eq 0 ]]
    then
        checkForStuckServer
    fi
    sleep 2
done

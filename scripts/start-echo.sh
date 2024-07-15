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

# for n 1 to instanceCount
# logpath="logs/$HOSTNAME/$n
# flags=...logpath...
# mkdir ...
# mv ...

#create the Log directory 
mkdir /ready-at-dawn-echo-arena/logs/$HOSTNAME/old 2> /dev/null

#make pids directory
mkdir /ready-at-dawn-echo-arena/pids 2> /dev/null

region='euw'
echo "Going to start $INSTANCES instances of echovr"
# Function to find the first available port within a range
# Usage: find_available_port start_port end_port
function find_available_port {
    start_port=$1
    end_port=$2

    # Loop through the port range and check each port
    for (( port=start_port; port<=end_port; port++ )); do
        # Check if the port is open
        timeout 1 bash -c "echo >/dev/tcp/localhost/$port" 2>/dev/null
        if [ $? -ne 0 ]; then
            echo "$port"
            return
        fi
    done

    echo "No available port found in the range $start_port-$end_port"
}
# choose the number of instance of echo server you want to run by setting the env variable INSTANCES
for i in $(seq 1 $INSTANCES); do
    logpath="logs/$HOSTNAME/$i"
    echo "Using logpath $logpath"
    # GIVEN THIS RANGE
    first_available_port=$(find_available_port $EVR_PORT_START $EVR_PORT_END)
    #move old log files
    mv /ready-at-dawn-echo-arena/logs/$HOSTNAME/$i/*.log /ready-at-dawn-echo-arena/logs/$HOSTNAME/old
    #$port is set as an environment variable
    flags="-noovr -server -headless -timestep 120 -fixedtimestep -nosymbollookup -port $port -logpath $first_available_port -noconsole -serverregion $region"
 #puts the process id into a pid file for this instance
    pidfile="/ready-at-dawn-echo-arena/pids/${i}.pid"

    echo "Using pid file ${pidfile}"

    #start the echo server process
    nohup /usr/bin/wine /ready-at-dawn-echo-arena/bin/win10/echovr.exe $flags 1>/dev/null 2>&1 &
    
    echo $! > "$pidfile"
    # echo "Starting dummy for instance $i"
    # bash /scripts/dummy.sh $i &

done


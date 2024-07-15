#!/bin/bash

instance="$1"


bash /scripts/checkForStuckServer.sh $instance &
bash /scripts/error-check.sh $instance

#this is for running this script infinitely, so the container doesnt exit
tail -f /dev/null

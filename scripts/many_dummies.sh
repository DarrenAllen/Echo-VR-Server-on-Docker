#!/bin/bash
# for each instance, start the health checks of echovr
for i in $(seq 1 $INSTANCES); do
    bash /scripts/dummy.sh $i &
done


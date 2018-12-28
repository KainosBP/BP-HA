#!/bin/bash
#
# Script Created by J.T. Buice | kainosbp.com
#

tail -n 500 /telos/data/log/stderr.txt | grep "on_incoming_block" | grep "kainos" > /dev/null 2>&1
        if [ $? -ne 0 ]
        then
        echo "BP NOT OK" >> /home/jbuice/bp_monitor.log
        mail -s "BP1 DOWN!! Starting Failover" jbuice@kainostech.com < /dev/null
        fi

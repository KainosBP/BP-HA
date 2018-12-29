#!/bin/bash
#
# Script Created by J.T. Buice | kainosbp.com
#
# You will need to adjust a few things below including the variables and the paths for your nodeos install and config.ini locations.
# This HA method will cause you to miss less blocks than regproding a new key but you will need to also run
#

time=`date '+%Y-%m-%d %H:%M:%S'`

#Set these vars for your setup
bpname=YOURBPNAME
email1=YOUR EMAIL1
email2=YOUR SMS NUMBER@mms.att.net


tail -n 400 /telos/data/log/stderr.txt | grep "on_incoming_block" | grep "$bpname" > /dev/null 2>&1
  if [ $? -ne 0 ]
    then
        echo "BP NOT OK $time" >> /home/jbuice/bp_monitor.log
        mail -s "BP1 DOWN!! Starting Failover" $email1 < /dev/null
        mail -s "BP1 DOWN!! Starting Failover" $email2 < /dev/null
        mv /telos/data/config.ini /telos/data/config.ini.old
        mv /telos/data/config.ini.standby /telos/data/config.ini
        pkill nodeos
        sleep 5
        echo "/telos/oak-v1.4.5/build/programs/nodeos/nodeos --data-dir /telos/data --config-dir /telos/data &>> /telos/data/log/stderr.txt &" | bash -
        mv /home/jbuice/standbymonitor.sh /home/jbuice/standbymonitor.sh.off
    else
        echo "BP CHECK OK $time" >> /home/jbuice/bp_monitor.log
    fi

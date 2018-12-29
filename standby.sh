#!/bin/bash
#
# BP High Availability Script Created by J.T. Buice | kainosbp.com
#
# This is a simple script to monitor the last 400 lines of your nodeos output for your BP name. If it doesn't show up, the script will
# register your standby key and your standby BP node running this signing key will kick in after approx 4 full rotations. 
# I have the script running via cron every 60 seconds. Based on tests, the longest it takes to figure out your node is offline and
# the standby to kick in is around 8 minutes and 72 blocks which is not enough to be kicked. 
# I recomend running this on an isolated seed node without API traffic to keep extra nodeos output down.
#

time=`date '+%Y-%m-%d %H:%M:%S'`

#Set these vars for your setup
bpname=YOUR BP ACCT NAME
email1=YOUR EMAIL
email2=YOUR ATT SMS#@mms.att.net
walletpw=Monitor Node Wallet Password
standbysignkey=StandbySigningKey

tail -n 400 /telos/data/log/stderr.txt | grep "on_incoming_block" | grep "$bpname" > /dev/null 2>&1
  if [ $? -ne 0 ]
    then
        echo "BP NOT OK $time" >> /telos/bp_monitor.log
        mail -s "BP1 DOWN!! Starting Failover" $email1 < /dev/null
        mail -s "BP1 DOWN!! Starting Failover" $email2 < /dev/null
        echo "/telos/oak-v1.4.5/build/programs/teclos/teclos wallet unlock --password $walletpw" | bash -
        echo "/telos/oak-v1.4.5/build/programs/teclos/teclos system regproducer $bpname $standbysignkey https://www.kainosbp.com 840" | bash -
    else
        echo "BP CHECK OK $time" >> /telos/bp_monitor.log
    fi

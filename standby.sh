#!/bin/bash
#
# BP High Availability Script Created by J.T. Buice | kainosbp.com
#
# This is a simple script to monitor the last 400 lines of your nodeos output for your BP name. If it doesn't show up, the script will
# register your standby key and your standby BP node running this signing key will kick in after approx 4 full rotations. 
# I have the script running via cron every 60 seconds. Based on tests, the longest it takes to figure out your node is offline and
# the standby to kick in is around 8 minutes and 72 blocks which is not enough to be kicked. 
# I recommend running this on an isolated seed node without API traffic to keep extra nodeos output down.
# Requirement for email alert to work is sendmail or postfix setup and configured to send email with mailutils installed. 
#

time=`date '+%Y-%m-%d %H:%M:%S'`

#Set these vars for your setup
bpname=YOUR BP ACCT NAME
email1=YOUR EMAIL
email2=YOUR ATT SMS#@mms.att.net
walletpw=Monitor Node Wallet Password
standbysignkey=StandbySigningKey

#Modify your nodeos output locaton here.
tail -n 400 /telos/data/log/stderr.txt | grep "_block" | grep "$bpname" > /dev/null 2>&1
  if [ $? -ne 0 ]
    then
        echo "BP NOT OK $time" >> /telos/bp_monitor.log #Edit the path for your log output here
        mail -s "BP1 DOWN!! Starting Failover" $email1 < /dev/null
        mail -s "BP1 DOWN!! Starting Failover" $email2 < /dev/null
        #Edit teclos path here
        echo "/telos/oak-v1.4.5/build/programs/teclos/teclos wallet unlock --password $walletpw" | bash -
        #Optional Enter your website and node location also.
        echo "/telos/oak-v1.4.5/build/programs/teclos/teclos system regproducer $bpname $standbysignkey" | bash -
    else
        echo "BP CHECK OK $time" >> /telos/bp_monitor.log #Edit path for log output here
    fi

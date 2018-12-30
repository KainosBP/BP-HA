# BP-HA
Script to monitor for Block Production and take action if production stops

BP High Availability Script Created by J.T. Buice | kainosbp.com

If you like this, please vote for kainosblkpro!

This is a simple script to monitor the last 400 lines of your nodeos output for your BP name. If it doesn't show up, the script will register your standby key and your standby BP node running this signing key will kick in after approx 4 full rotations.  

I have the script running via cron every 60 seconds. Based on tests, the longest it takes to figure out your node is offline and the standby to kick in is around 8 minutes and 72 blocks which is not enough to be kicked. 

I recommend running this on an isolated seed node without API traffic to keep extra nodeos output down.

Please be sure to look at the script and fill in your info where noted.

Requirement for email alert to work is sendmail or postfix setup and configured to send email with mailutils installed. 

#!/bin/bash

# execute id command
id
 
# make directory if unexist
DIR=./pinglog

if [ ! -d $DIR ]; then
mkdir $DIR
echo -e "directory created"
fi
 
# variables
LOGDIR=$DIR
NOW=$(date +"%Y%m%d-%H%M%S")
 
OKLOG=$LOGDIR/hostcheck_$NOW.log
NGLOG=$LOGDIR/hostcheck_error_$NOW.log
 
# check ping reply
while read line; do
hosts=$(echo $line | grep -v ^# | grep -v ^$ | grep -v localhost | cut -d " " -f 2)
 
# ping to hosts
if [ -n "$hosts" ]; then
ping -c 1 $hosts > /dev/null 2>&1
 
# it got reply "hostname : OK" else "hostname : NG"
# output OK-log and NG-log file

if [ $? -eq 0 ]; then
echo -e "$hosts : OK" >> $OKLOG
else
echo -e "$hosts : NG" >> $NGLOG
fi
fi
done < /etc/hosts
 
echo -e "done"

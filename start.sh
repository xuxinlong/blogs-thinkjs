#!/bin/sh

str=`ps -ef | grep development.js | grep -v 'grep' | awk '{print$2}'`
for pid in `echo "$str" | sed 's/,/\n/g'`
do
	echo "pid: $pid"
	kill -9 $pid
done
node ./development.js

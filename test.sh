#!/bin/sh
echo ' 服务器处理 '
ssh root@47.104.157.93 << eeooff
	# uname -a
	# id
	cd /data/app/service
	
	echo "kill 掉已经存在的 production.js 进程"
	# ps
	# str=`ps -ef | grep production.js | grep -v 'grep' | awk '{print $2}'`
	# ps -ef | grep production.js | grep -v 'grep' | awk '{print $2}'
	# ps -ef | grep production.js | grep -v 'grep' > a.log
	# awk '{print \$2}' a.log >b.log
	# awk '{print \$2}'

	str="ps -ef | grep production.js | grep -v 'grep' | awk '{print \$2}'"
	echo "进程：$str"
	# ps -ef | grep production.js | grep -v 'grep' | awk '{print \$2}'
	# ps -ef | grep production.js | grep -v 'grep' | awk '{print \$2}' | xargs kill -9
	# for pid in $str
	# do
	# 	echo "production.js 进程 pid: $pid"
	# 	kill -9 $pid
	# done
	sh ./blogs-thinkjs/start1.sh
	echo "启动服务，后台运行"

	node blogs-thinkjs/production.js > service.log 2>&1 &
	exit 
eeooff
echo Finished: SUCCESS!
